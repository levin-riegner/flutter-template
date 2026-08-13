import 'package:color_picker/data/corrector/model/correction.dart';

/// Pure-Dart, on-device text corrector.
///
/// No network, no native plugins — a small built-in dictionary plus rule-based
/// fixes (common typos, repeated-letter collapse, sentence capitalization and
/// whitespace cleanup). It returns a [Correction] describing every change that
/// was applied against the original string.
class CorrectorService {
  /// Small built-in dictionary of common misspellings (lower-case key).
  static const Map<String, String> _dictionary = {
    'teh': 'the',
    'recieve': 'receive',
    'seperate': 'separate',
    'similiar': 'similar',
    'occured': 'occurred',
    'definately': 'definitely',
    'adress': 'address',
    'neccessary': 'necessary',
    'wich': 'which',
    'aquire': 'acquire',
    'begining': 'beginning',
    'calender': 'calendar',
    'beleive': 'believe',
    'wierd': 'weird',
    'goverment': 'government',
    'existance': 'existence',
  };

  static final RegExp _letter = RegExp(r'[A-Za-z]');

  bool _isLetter(String ch) => _letter.hasMatch(ch);

  bool _isPunctuation(String ch) =>
      ch == '.' || ch == ',' || ch == '!' || ch == '?' || ch == ';' ||
      ch == ':';

  bool _isSentenceEnd(String ch) => ch == '.' || ch == '!' || ch == '?';

  /// Corrects [content] and returns a [Correction] with the fixed text and a
  /// list of individual [Fix]es (each with an index into the original string).
  Future<Correction> correct(String content) async {
    final fixes = <Fix>[];
    final out = StringBuffer();
    var i = 0;
    final n = content.length;
    var sentenceStart = true;

    while (i < n) {
      final ch = content[i];
      if (_isLetter(ch)) {
        // Scan a whole word so we can apply dictionary / repeat / case rules.
        final wordStart = i;
        final wordBuf = StringBuffer();
        while (i < n && _isLetter(content[i])) {
          wordBuf.write(content[i]);
          i++;
        }
        final word = wordBuf.toString();
        out.write(_fixWord(word, wordStart, sentenceStart, fixes));
        sentenceStart = false;
      } else if (ch == ' ') {
        // Whitespace cleanup: collapse runs and drop spaces before punctuation.
        final wsStart = i;
        while (i < n && content[i] == ' ') {
          i++;
        }
        final runLength = i - wsStart;
        final nextIsPunct = i < n && _isPunctuation(content[i]);
        if (nextIsPunct) {
          fixes.add(Fix(
            index: wsStart,
            replacement: '',
            reason: 'Removed space before punctuation',
          ));
        } else if (runLength > 1) {
          out.write(' ');
          fixes.add(Fix(
            index: wsStart,
            replacement: ' ',
            reason: 'Collapsed multiple spaces',
          ));
        } else {
          out.write(' ');
        }
      } else {
        out.write(ch);
        if (_isSentenceEnd(ch)) {
          sentenceStart = true;
        }
        i++;
      }
    }

    return Correction(
      original: content,
      corrected: out.toString(),
      fixes: fixes,
    );
  }

  String _fixWord(
    String word,
    int wordStart,
    bool sentenceStart,
    List<Fix> fixes,
  ) {
    var newWord = word;
    String? reason;

    // 1. Dictionary typo fix (case-insensitive key, preserves leading case).
    final dict = _dictionary[word.toLowerCase()];
    if (dict != null) {
      newWord = _applyCase(dict, word);
      reason = 'Fixed common typo';
    } else {
      // 2. Collapse repeated letters (runs of 3+ -> 2).
      final collapsed = _collapseRepeated(word);
      if (collapsed != word) {
        newWord = collapsed;
        reason = 'Collapsed repeated letters';
      }
    }

    // 3. Capitalize the first word of a sentence (also applies to a word that
    //    was fixed above, e.g. "teh" at the start becomes "The").
    if (sentenceStart && newWord.isNotEmpty) {
      final capped = _capitalize(newWord);
      if (reason == null && capped != newWord) {
        reason = 'Capitalized start of sentence';
      }
      newWord = capped;
    }

    if (newWord != word) {
      fixes.add(Fix(
        index: wordStart,
        replacement: newWord,
        reason: reason ?? 'Corrected word',
      ));
    }
    return newWord;
  }

  // Matches a run of 3+ identical letters (e.g. "ooo" in "hellooo").
  static final RegExp _repeatRun = RegExp(r'([a-zA-Z])\1\1+');

  String _collapseRepeated(String word) {
    return word.replaceAllMapped(
      _repeatRun,
      (match) => '${match[1]}',
    );
  }

  String _capitalize(String word) {
    if (word.isEmpty || word[0] == word[0].toUpperCase()) return word;
    return word[0].toUpperCase() + word.substring(1);
  }

  String _applyCase(String replacement, String original) {
    if (original.isNotEmpty && original[0] == original[0].toUpperCase() &&
        replacement.isNotEmpty) {
      return replacement[0].toUpperCase() + replacement.substring(1);
    }
    return replacement;
  }
}
