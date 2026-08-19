import 'package:dio/dio.dart';
import 'package:swiss_ai/data/research/model/search_result.dart';
import 'package:swiss_ai/data/shared/service/remote/api_response_mapper.dart';

/// Key-less web search + page fetching via DuckDuckGo's Lite endpoint.
///
/// Pure-Dart: no native plugins, works on web. [search] returns the top
/// organic results for [query]; [fetchPage] returns the readable text of a
/// page (tags stripped), capped at [maxLength] characters.
class WebResearchService with ApiResponseMapper {
  final Dio client;
  final String _liteUrl = 'https://lite.duckduckgo.com/lite/';

  WebResearchService(this.client);

  /// Returns up to [limit] organic results for [query].
  Future<List<SearchResult>> search(String query, {int limit = 5}) async {
    try {
      final resp = await client.get(
        _liteUrl,
        queryParameters: {'q': query},
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            'User-Agent': 'Mozilla/5.0 (compatible; swiss_ai/1.0; +research)',
          },
        ),
      );
      final html = resp.data is String ? resp.data as String : '';
      final results = _parseResults(html);
      return results.length > limit ? results.take(limit).toList() : results;
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  /// Fetches [url] and returns readable text with tags stripped.
  Future<String> fetchPage(String url, {int maxLength = 20000}) async {
    try {
      final resp = await client.get(
        url,
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (X11; Linux x86_64; research) AppleWebKit/537.36',
          },
        ),
      );
      final html = resp.data is String ? resp.data as String : '';
      final text = _stripToText(html);
      return text.length > maxLength ? text.substring(0, maxLength) : text;
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  // --- parsing helpers ---

  /// DuckDuckGo Lite wraps result links in
  /// `//duckduckgo.com/l/?uddg=<encoded>` redirectors; unwrap to the real URL.
  static String _unwrapUddg(String href) {
    const prefix = 'uddg=';
    final idx = href.indexOf(prefix);
    if (idx == -1) return href;
    var encoded = href.substring(idx + prefix.length);
    final amp = encoded.indexOf('&');
    if (amp != -1) encoded = encoded.substring(0, amp);
    try {
      return Uri.decodeComponent(encoded);
    } catch (_) {
      return encoded;
    }
  }

  List<SearchResult> _parseResults(String html) {
    final results = <SearchResult>[];
    // Match whole result-link <a> tags. Attribute order varies in DDG Lite
    // markup (href may precede or follow the class attribute), so capture
    // the tag and extract href + title from it separately.
    final anchorRe = RegExp(
      r"<a\b[^>]*class='?result-link'?[^>]*>[^<]*</a>",
      caseSensitive: false,
    );
    final snippetRe = RegExp(
      r"<td class='?result-snippet'?[^>]*>([\s\S]*?)</td>",
      caseSensitive: false,
    );

    final snippets = snippetRe.allMatches(html).toList();
    var kept = 0;
    for (final m in anchorRe.allMatches(html)) {
      final tag = m.group(0) ?? '';
      final hrefM = RegExp(r'href="([^"]+)"').firstMatch(tag);
      final rawHref = hrefM?.group(1) ?? '';
      final titleM = RegExp(r'>([^<]*)</a>').firstMatch(tag);
      final title = _cleanTag(titleM?.group(1) ?? '');
      final url =
          _unwrapUddg(rawHref.startsWith('http') ? rawHref : 'https:$rawHref');
      if (url.isEmpty ||
          url.contains('duckduckgo.com') ||
          url.contains('duck.co')) {
        continue;
      }
      if (title.isEmpty) continue;
      kept++;
      if (kept > 100) break; // safety cap
      // The snippet is the next result-snippet block after this link.
      String snippet = '';
      for (final sn in snippets) {
        if (sn.start >= m.end) {
          snippet = _cleanTag(sn.group(1) ?? '');
          break;
        }
      }
      results.add(SearchResult(title: title, url: url, snippet: snippet));
    }
    return results;
  }

  /// Removes HTML tags, collapses whitespace, decodes common entities.
  static String _cleanTag(String s) {
    var t = s.replaceAll(RegExp(r'<[^>]+>'), ' ');
    t = t
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .replaceAll('&nbsp;', ' ');
    return t.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String _stripToText(String html) {
    // Dart's RegExp has no backreferences, so strip each block type
    // explicitly.
    var t = html;
    t = t.replaceAll(
        RegExp(r'<script[^>]*>[\s\S]*?</script>', caseSensitive: false),
        '');
    t = t.replaceAll(
        RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false), '');
    t = t.replaceAll(
        RegExp(r'<noscript[^>]*>[\s\S]*?</noscript>', caseSensitive: false),
        '');
    t = t.replaceAll(RegExp(r'<[^>]+>'), ' ');
    t = t
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');
    return t
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n\s*\n+'), '\n');
  }
}
