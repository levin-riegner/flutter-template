import 'package:swiss_ai/data/corrector/service/local/corrector_service.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("CorrectorService", () {
    final service = CorrectorService();

    test("fixes a common typo and capitalizes sentence start", () async {
      final result = await service.correct("teh quick brown fox");
      assert(result.hasChanges);
      assert(result.corrected == "The quick brown fox");
      assert(
        result.fixes.any(
          (fix) =>
              fix.replacement == "The" &&
              fix.reason == "Fixed common typo",
        ),
      );
    });

    test("capitalizes a lower-case sentence start", () async {
      final result = await service.correct("hello there");
      assert(result.corrected == "Hello there");
      assert(result.fixes.any(
        (fix) =>
            fix.replacement == "Hello" &&
            fix.reason == "Capitalized start of sentence",
      ));
    });

    test("collapses repeated letters to a single letter", () async {
      final result = await service.correct("say hellooo");
      assert(result.corrected == "Say hello");
      assert(result.fixes.any(
        (fix) => fix.replacement == "hello" &&
            fix.reason == "Collapsed repeated letters",
      ));
    });

    test("collapses multiple spaces and drops space before punctuation",
        () async {
      final result = await service.correct("say hello   world ,now");
      assert(result.fixes.any(
        (fix) =>
            fix.replacement == " " &&
            fix.reason == "Collapsed multiple spaces",
      ));
      assert(result.fixes.any(
        (fix) =>
            fix.replacement == "" &&
            fix.reason == "Removed space before punctuation",
      ));
      assert(result.corrected == "Say hello world,now");
    });

    test("returns no changes for already-correct text", () async {
      final result = await service.correct("Hello world");
      assert(!result.hasChanges);
      assert(result.corrected == "Hello world");
      assert(result.fixes.isEmpty);
    });

    test("reports fixes with indices into the original string", () async {
      final result = await service.correct("teh teh");
      assert(result.fixes.length == 2);
      assert(result.fixes[0].index == 0);
      assert(result.fixes[1].index == 4);
    });
  });
}
