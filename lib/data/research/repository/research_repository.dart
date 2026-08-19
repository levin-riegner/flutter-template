import 'dart:convert';

import 'package:swiss_ai/data/chat/service/remote/chat_api_service.dart';
import 'package:swiss_ai/data/research/model/research_report.dart';
import 'package:swiss_ai/data/research/model/search_result.dart';
import 'package:swiss_ai/data/research/service/remote/web_research_service.dart';
import 'package:logging_flutter/logging_flutter.dart';

/// Deep research over the open web, grounded and on-device.
///
/// Pipeline: (1) plan sub-questions with the local LLM, (2) search + fetch
/// top sources with [WebResearchService], (3) extract grounded notes per
/// sub-question, (4) synthesize a sourced report with the local LLM.
///
/// Uses [ChatApiService] directly (stateless one-shot calls) instead of
/// [ChatRepository] so research prompts don't pollute the user's chat
/// history.
class ResearchRepository {
  final ChatApiService _api;
  final WebResearchService _web;

  ResearchRepository(this._api, this._web);

  Future<ResearchReport> research(
    String question, {
    int subquestionCount = 3,
    int resultsPerSubquestion = 3,
    int pageLimit = 10,
    String? Function(String stage)? progress,
  }) async {
    final q = question.trim();
    if (q.isEmpty) {
      throw FormatException('Research question is empty');
    }
    Flogger.i('Deep research: $q');

    // 1. Plan sub-questions.
    progress?.call('Planning sub-questions');
    final subquestions = await _planSubquestions(q, subquestionCount);

    // 2. Search + fetch sources.
    progress?.call('Searching the web');
    final pages = <String, String>{}; // url -> text
    for (final sub in subquestions) {
      final results =
          await _web.search(sub, limit: resultsPerSubquestion).catchError(
        (Object e) {
          Flogger.w('Search failed for "$sub": $e');
          return const <SearchResult>[];
        },
      );
      for (final r in results) {
        if (pages.length >= pageLimit) break;
        if (pages.containsKey(r.url)) continue;
        try {
          final text = await _web.fetchPage(r.url, maxLength: 20000);
          if (text.length >= 200) {
            pages[r.url] = text;
          }
        } catch (e) {
          Flogger.w('Fetch failed for ${r.url}: $e');
        }
      }
    }
    if (pages.isEmpty) {
      throw StateError('No web sources could be fetched '
          '(network blocked or search empty)');
    }
    Flogger.i('Gathered ${pages.length} sources');

    // 3. Extract grounded notes per sub-question.
    final notes = <ResearchNote>[];
    for (var i = 0; i < subquestions.length; i++) {
      progress?.call(
          'Analyzing sources (${i + 1}/${subquestions.length})');
      final sub = subquestions[i];
      // Budget: 6 pages of up to 4000 chars each, best-fit first.
      final budget = <MapEntry<String, String>>[];
      var chars = 0;
      for (final entry in pages.entries) {
        if (chars >= 24000) break;
        final slice = entry.value.length > 4000
            ? entry.value.substring(0, 4000)
            : entry.value;
        budget.add(MapEntry(entry.key, slice));
        chars += slice.length;
      }
      final raw = await _extractNotes(sub, budget, subquestions);
      for (final n in raw) {
        notes.add(ResearchNote(
            fact: n.fact, sourceUrl: n.sourceUrl.isNotEmpty ? n.sourceUrl : ''));
      }
    }

    // 4. Synthesize the report.
    progress?.call('Writing report');
    final summary = await _synthesize(q, subquestions, notes);

    return ResearchReport(
      question: q,
      subquestions: subquestions,
      notes: notes,
      summary: summary,
    );
  }

  // --- steps ---

  Future<List<String>> _planSubquestions(String question, int count) async {
    final sys =
        'You plan deep-research work on the web. Reply with ONLY a '
        'JSON object: {"subquestions":["q1","q2",...]} containing '
        '$count focused sub-questions that together cover the topic '
        'mechanism, causes, evidence, and practical implications. '
        'No prose, no code fences.';
    final raw = await _api.sendChat([
      {'role': 'system', 'content': sys},
      {'role': 'user', 'content': 'Topic: $question'},
    ], disableThinking: true);
    try {
      final decoded = jsonDecode(_fence(raw));
      final list = (decoded is Map ? decoded['subquestions'] : decoded);
      if (list is List) {
        final items =
            list.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
        return items.isEmpty
            ? [question]
            : items.length > count
                ? items.take(count).toList()
                : items;
      }
    } catch (e) {
      Flogger.w('Could not parse sub-question plan ($e); using single pass');
    }
    return [question];
  }

  Future<List<_RawNote>> _extractNotes(
    String subquestion,
    List<MapEntry<String, String>> pages,
    List<String> allSubquestions,
  ) async {
    final context = pages
        .map((e) => '[SOURCE ${e.key}]\n${e.value}')
        .join('\n\n');
    const sys = 'You extract research notes. You are given one sub-question '
        'and several numbered sources. Reply with ONLY a JSON array of '
        'objects: {"fact":"one concise, self-contained fact relevant to the '
        'sub-question","source_url":"the exact source URL the fact came '
        'from"}. Ground every fact strictly in the provided sources — '
        'never invent. 3-6 facts. No prose, no code fences.';
    final user =
        'Sub-question: $subquestion\n\n=== SOURCES ===\n$context\n=== END ===';
    final raw = await _api.sendChat(
      [
        {'role': 'system', 'content': sys},
        {'role': 'user', 'content': user},
      ],
      disableThinking: true,
    );
    try {
      final decoded = jsonDecode(_fence(raw));
      if (decoded is List) {
        return decoded.whereType<Map>().map((m) {
          final url = (m['source_url'] ?? m['sourceUrl'] ?? '').toString();
          return _RawNote(
            fact: (m['fact'] ?? '').toString().trim(),
            sourceUrl: url,
          );
        }).where((n) => n.fact.isNotEmpty).toList();
      }
    } catch (e) {
      Flogger.w('Note extraction parse failed: $e');
    }
    return const [];
  }

  Future<String> _synthesize(
    String question,
    List<String> subquestions,
    List<ResearchNote> notes,
  ) async {
    final notesText = notes
        .map((n) => '- ${n.fact} (source: ${n.sourceUrl})')
        .join('\n');
    final subs = subquestions.map((s) => '- $s').join('\n');
    const sys = 'You write a deep-research report in markdown. Use the '
        'provided sourced notes only — do not add unverified claims. '
        'Structure: "## Answer" (direct synthesis), "## Evidence" '
        '(key findings, each citing its source URL in parentheses), and '
        '"## Sources" (deduplicated list of source URLs). 300-500 words.';
    return _api.sendChat([
      {'role': 'system', 'content': sys},
      {
        'role': 'user',
        'content':
            'Question: $question\n\nSub-questions:\n$subs\n\nSourced notes:\n$notesText'
      },
    ]);
  }

  /// Strips markdown fences/leading whitespace around JSON.
  static String _fence(String raw) {
    var t = raw.trim();
    final start = t.indexOf('{');
    final end = t.lastIndexOf('}');
    final sArr = t.indexOf('[');
    final eArr = t.lastIndexOf(']');
    int open, close;
    if (sArr >= 0 && (start < 0 || sArr < start)) {
      open = sArr;
      close = eArr;
    } else {
      open = start;
      close = end;
    }
    if (open >= 0 && close > open) t = t.substring(open, close + 1);
    return t;
  }
}

class _RawNote {
  final String fact;
  final String sourceUrl;
  const _RawNote({required this.fact, required this.sourceUrl});
}
