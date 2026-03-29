import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/data/services/storage_service.dart';

class CustomAffirmationService {
  final StorageService _storage;

  CustomAffirmationService(this._storage);

  List<Affirmation> getCustomAffirmations() {
    final jsonList = _storage.getJsonList(StorageService.customAffirmations);
    if (jsonList == null) return [];
    return jsonList.map((j) => Affirmation.fromJson(j)).toList();
  }

  Future<void> saveCustomAffirmation(String text) async {
    final customs = getCustomAffirmations();
    final affirmation = Affirmation(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      category: AffirmationCategory.selfLove,
    );
    customs.add(affirmation);
    await _storage.setJsonList(
      StorageService.customAffirmations,
      customs.map((a) => a.toJson()).toList(),
    );
  }

  Future<void> deleteCustomAffirmation(String id) async {
    final customs = getCustomAffirmations();
    customs.removeWhere((a) => a.id == id);
    await _storage.setJsonList(
      StorageService.customAffirmations,
      customs.map((a) => a.toJson()).toList(),
    );
  }

  /// Mock AI suggestions for "I Am..." builder
  List<String> getAiSuggestions(String prefix) {
    final suggestions = [
      'I am worthy of love and abundance.',
      'I am a powerful creator of my reality.',
      'I am aligned with my highest purpose.',
      'I am grateful for this beautiful life.',
      'I am radiating positive energy.',
      'I am attracting miracles every day.',
      'I am becoming the best version of myself.',
      'I am surrounded by infinite possibilities.',
      'I am deserving of all my dreams coming true.',
      'I am a beacon of light and love.',
    ];

    if (prefix.isEmpty) return suggestions;

    return suggestions
        .where((s) => s.toLowerCase().contains(prefix.toLowerCase()))
        .toList();
  }
}
