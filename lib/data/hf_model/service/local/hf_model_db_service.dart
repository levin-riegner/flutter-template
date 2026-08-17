import 'package:swiss_ai/data/hf_model/model/hf_model.dart';

/// Local persistence for the chosen model shortlist.
///
/// Pure-Dart in-memory store (same convention as ChatDbService) so the model
/// discovery feature stays testable on the host without native plugins.
class HfModelDbService {
  final List<HfModel> _store = [];

  Future<List<HfModel>> getModels() async {
    return List.unmodifiable(_store);
  }

  Future<void> saveModels(List<HfModel> models) async {
    _store
      ..clear()
      ..addAll(models);
  }

  Future<void> clear() async {
    _store.clear();
  }
}
