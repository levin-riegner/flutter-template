import 'package:swiss_ai/data/hf_model/model/hf_model.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("HfModel licence double-check", () {
    HfModel model({String id = 'org/x', String? license = 'apache-2.0'}) =>
        HfModel(id: id, license: license, downloads: 1);

    test("allows explicit permissive licence (Apache-2.0)", () {
      assert(model(license: 'Apache-2.0').isCommercialSafe);
      assert(model(license: 'MIT').isCommercialSafe);
      assert(model(license: 'llama3.2').isCommercialSafe);
    });

    test("rejects explicit restricted licence even for a known family", () {
      // CC-BY-NC must never pass, regardless of family name.
      assert(!model(id: 'org/qwen2.5-7b', license: 'cc-by-nc-4.0').isCommercialSafe);
      assert(!model(license: 'non-commercial').isCommercialSafe);
      assert(!model(id: 'org/llama-3.2-1b', license: 'llama2').isCommercialSafe);
    });

    test("unknown/absent licence fails closed unless family is on allow-list",
        () {
      // Unknown licence + unknown family => excluded.
      assert(!model(id: 'org/mystery-model', license: 'weird-license-xyz')
          .isCommercialSafe);
      // Absent licence + unknown family => excluded.
      assert(!model(id: 'org/mystery-model', license: null).isCommercialSafe);
      // Absent licence + known commercial family => allowed via cross-check.
      assert(model(id: 'org/qwen2.5-7b', license: null).isCommercialSafe);
      assert(model(id: 'org/ministral-8b', license: null).isCommercialSafe);
    });

    test("restricted gate wins over permissive gate", () {
      // Even if the family token looks safe, an explicit NC licence blocks it.
      assert(!model(id: 'org/qwen2.5-70b', license: 'cc-by-nc-sa-4.0')
          .isCommercialSafe);
    });
  });

  group("HfModel parsing", () {
    test("parses cardData licence and downloads from HF payload", () {
      final model = HfModel.fromJson({
        'id': 'org/qwen2.5-1.5b',
        'downloads': 1234,
        'pipeline_tag': 'text-generation',
        'cardData': {'license': 'Apache-2.0'},
      });
      assert(model.id == 'org/qwen2.5-1.5b');
      assert(model.downloads == 1234);
      assert(model.pipelineTag == 'text-generation');
      assert(model.license == 'Apache-2.0');
      assert(model.isCommercialSafe);
    });

    test("handles missing licence and cardData gracefully", () {
      final model = HfModel.fromJson({
        'id': 'org/qwen2.5-0.5b',
        'downloads': 50,
      });
      assert(model.license == null);
      // Known commercial family => still allowed.
      assert(model.isCommercialSafe);
    });
  });
}
