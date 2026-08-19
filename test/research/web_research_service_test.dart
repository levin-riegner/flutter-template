import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swiss_ai/data/research/service/remote/web_research_service.dart';

class _MockDio extends Mock implements Dio {}

/// Minimal DuckDuckGo Lite HTML fixture — markup shape matches live
/// lite.duckduckgo.com (link <a> row first, snippet <td> row second).
const _liteHtml = '''
<html><body><table>
<tr>
<td valign="top">1.&nbsp;</td>
<td>
<a rel="nofollow" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Fexample.com%2Fpage1&amp;rut=abc" class='result-link'>First Title</a>
</td>
</tr>
<tr>
<td>&nbsp;&nbsp;&nbsp;</td>
<td class='result-snippet'>First <b>snippet</b> text here.</td>
</tr>
<tr>
<td valign="top">2.&nbsp;</td>
<td>
<a rel="nofollow" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Fexample.org%2Fpage2&amp;rut=bcd" class='result-link'>Second Title</a>
</td>
</tr>
<tr>
<td>&nbsp;&nbsp;&nbsp;</td>
<td class='result-snippet'>Second snippet.</td>
</tr>
</table></body></html>
''';

void main() {
  late Dio dio;
  late WebResearchService service;

  setUp(() {
    dio = _MockDio();
    service = WebResearchService(dio);
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Options());
  });

  group('search', () {
    test('parses and unwraps uddg results', () async {
      when(() => dio.get(any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
          data: _liteHtml,
        ),
      );

      final results = await service.search('query', limit: 10);

      expect(results, hasLength(2));
      expect(results[0].title, 'First Title');
      expect(results[0].url, 'https://example.com/page1');
      expect(results[0].snippet, 'First snippet text here.');
      expect(results[1].url, 'https://example.org/page2');
      expect(results[1].snippet, 'Second snippet.');
    });

    test('respects limit', () async {
      when(() => dio.get(any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
          data: _liteHtml,
        ),
      );

      final results = await service.search('query', limit: 1);
      expect(results, hasLength(1));
    });

    test('returns empty for html with no results', () async {
      when(() => dio.get(any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
          data: '<html><body>no results</body></html>',
        ),
      );

      final results = await service.search('query');
      expect(results, isEmpty);
    });

    test('skips duckduckgo self-links', () async {
      const self = '''
<html><body><table>
<tr>
<td>
<a rel="nofollow" href="https://duckduckgo.com/about" class='result-link'>Skip Me</a>
</td>
</tr>
<tr>
<td>
<a rel="nofollow" href="//duckduckgo.com/l/?uddg=https%3A%2F%2Fexample.com%2Fx&amp;rut=zzz" class='result-link'>Keep Me</a>
</td>
</tr>
</table></body></html>
''';
      when(() => dio.get(any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
          data: self,
        ),
      );

      final results = await service.search('query');
      expect(results, hasLength(1));
      expect(results.single.url, 'https://example.com/x');
    });
  });

  group('fetchPage', () {
    test('strips tags, scripts and entities', () async {
      when(() => dio.get(any(),
          options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
          data:
              '<html><head><style>p{}</style></head><body><script>var x=1;</script><p>Hello &amp; world &lt;tag&gt;</p></body></html>',
        ),
      );

      final text = await service.fetchPage('https://example.com');
      expect(text, contains('Hello & world <tag>'));
      expect(text, isNot(contains('var x')));
      expect(text, isNot(contains('<p>')));
    });

    test('caps length', () async {
      when(() => dio.get(any(),
          options: any(named: 'options'))).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
          data: 'a' * 100,
        ),
      );

      final text = await service.fetchPage('https://example.com',
          maxLength: 10);
      expect(text.length, 10);
    });
  });
}
