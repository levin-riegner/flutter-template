import 'package:affirmup/data/services/storage_service.dart';

class ReviewPromptService {
  final StorageService _storage;

  ReviewPromptService(this._storage);

  static const int triggerSessionCount = 5;
  static const int cooldownDays = 60;

  int getSessionCount() {
    return _storage.getInt(StorageService.sessionCount) ?? 0;
  }

  Future<void> incrementSession() async {
    final count = getSessionCount() + 1;
    await _storage.setInt(StorageService.sessionCount, count);
  }

  DateTime? getLastPromptDate() {
    final str = _storage.getString(StorageService.lastReviewPrompt);
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  Future<void> setLastPromptDate(DateTime date) async {
    await _storage.setString(
      StorageService.lastReviewPrompt,
      date.toIso8601String(),
    );
  }

  bool shouldPrompt() {
    final count = getSessionCount();
    if (count < triggerSessionCount) return false;

    final lastPrompt = getLastPromptDate();
    if (lastPrompt == null) return true;

    final daysSince = DateTime.now().difference(lastPrompt).inDays;
    return daysSince >= cooldownDays;
  }

  Future<void> markPrompted() async {
    await setLastPromptDate(DateTime.now());
  }
}
