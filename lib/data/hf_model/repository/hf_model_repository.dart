import 'package:swiss_ai/data/hf_model/model/hf_model.dart';
import 'package:swiss_ai/data/hf_model/service/local/hf_model_db_service.dart';
import 'package:swiss_ai/data/hf_model/service/remote/hf_model_api_service.dart';
import 'package:logging_flutter/logging_flutter.dart';

/// Repository for discovering downloadable models.
///
/// Fetches popular models from the HuggingFace Hub, keeps only models the app
/// may legally ship (commercial-safe licences), ranks by downloads, and exposes
/// the top [topN] as the user's shortlist.
class HfModelRepository {
  final HfModelApiService _apiService;
  final HfModelDbService _dbService;
  final int topN;
  final Set<String> _onDeviceFamilies;

  HfModelRepository(
    this._apiService,
    this._dbService, {
    this.topN = 3,
  }) : _onDeviceFamilies = {
        // Small efficient families well-suited to on-device inference.
        'gemma-2', 'smol', 'qwen2.5', 'llama-3.2', 'phi-3', 'mistral-large',
        'ministral', 'crystal',
      };

  Future<List<HfModel>> getCachedModels() async {
    return _dbService.getModels();
  }

  /// Refresh the shortlist from the Hub. Returns the top [topN] commercial-safe
  /// models, ranked by downloads.
  Future<List<HfModel>> refreshShortlist({
    String pipelineTag = "text-generation",
  }) async {
    Flogger.i("Refreshing model shortlist (top $topN)");

    final rawModels =
        await _apiService.fetchModels(pipelineTag: pipelineTag, limit: 60);
    final ranked = <HfModel>[];
    final seen = <String>{};

    for (final json in rawModels) {
      final model = HfModel.fromJson(json);
      if (!model.isCommercialSafe) continue; // licence gate
      if (!_onDeviceFamilies.any((f) => model.id.toLowerCase().contains(f))) {
        continue; // not suited to on-device size
      }
      if (!seen.add(model.id)) continue; // dedupe
      ranked.add(model);
    }

    ranked.sort((a, b) => b.downloads.compareTo(a.downloads));
    final top = ranked.take(topN).toList();

    await _dbService.saveModels(top);
    return top;
  }
}
