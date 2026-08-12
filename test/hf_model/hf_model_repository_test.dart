import 'package:color_picker/data/hf_model/repository/hf_model_repository.dart';
import 'package:color_picker/data/hf_model/service/local/hf_model_db_service.dart';
import 'package:color_picker/data/hf_model/service/remote/hf_model_api_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/scaffolding.dart';

class _MockApiService extends Mock implements HfModelApiService {}

void main() {
  group("HfModelRepository", () {
    final dbService = HfModelDbService();
    final apiService = _MockApiService();
    final repository = HfModelRepository(apiService, dbService);
    setUp(() {
      reset(apiService);
      dbService.clear();
    });

    test("returns a commercial-safe top-3 ranked by downloads", () async {
      when(() => apiService.fetchModels(
            pipelineTag: any(named: 'pipelineTag'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
        {
          'id': 'org/qwen2.5-7b',
          'downloads': 9000,
          'cardData': {'license': 'Apache-2.0'},
        },
        {
          'id': 'org/gemma-2-2b',
          'downloads': 7000,
          'cardData': {'license': 'apache-2.0'},
        },
        {
          'id': 'org/model-huge-70b',
          'downloads': 81000,
          'cardData': {'license': 'apache-2.0'},
        },
        {
          'id': 'org/noncommercial-model',
          'downloads': 5000,
          'cardData': {'license': 'cc-by-nc-4.0'},
        },
      ]);

      final top = await repository.refreshShortlist();
      // Non-commercial + non-on-device models are excluded; only the two
      // commercial on-device models remain, ranked by downloads.
      assert(top.length == 2);
      assert(top.every((m) => m.isCommercialSafe));
      assert(top[0].id == 'org/qwen2.5-7b');
      assert(top[1].id == 'org/gemma-2-2b');
    });

    test("caches the shortlist locally", () async {
      when(() => apiService.fetchModels(
            pipelineTag: any(named: 'pipelineTag'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
        {'id': 'org/qwen2.5-1.5b', 'downloads': 10},
      ]);

      await repository.refreshShortlist();
      final cached = await repository.getCachedModels();
      assert(cached.length == 1);
      assert(cached.first.id == 'org/qwen2.5-1.5b');
    });
  });
}
