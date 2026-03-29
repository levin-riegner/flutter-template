import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/data/services/storage_service.dart';

class DailyRoutineService {
  final StorageService _storage;

  DailyRoutineService(this._storage);

  String _todayStr() {
    final today = DateTime.now();
    return '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  }

  // ─── Morning / Evening ───

  bool isMorningCompleted() {
    final date = _storage.getString(StorageService.lastCompletionDate);
    if (date != _todayStr()) return false;
    return _storage.getBool(StorageService.morningCompleted) ?? false;
  }

  bool isEveningCompleted() {
    final date = _storage.getString(StorageService.lastCompletionDate);
    if (date != _todayStr()) return false;
    return _storage.getBool(StorageService.eveningCompleted) ?? false;
  }

  Future<void> completeMorning() async {
    await _storage.setString(StorageService.lastCompletionDate, _todayStr());
    await _storage.setBool(StorageService.morningCompleted, true);
    await _updateStreak();
  }

  Future<void> completeEvening() async {
    await _storage.setString(StorageService.lastCompletionDate, _todayStr());
    await _storage.setBool(StorageService.eveningCompleted, true);
    await _updateStreak();
  }

  // ─── Streak ───

  Future<void> _updateStreak() async {
    final lastDate = _storage.getString('streak_last_date');
    final today = _todayStr();

    if (lastDate == today) return; // Already updated today

    int current = _storage.getInt(StorageService.currentStreak) ?? 0;
    int longest = _storage.getInt(StorageService.longestStreak) ?? 0;
    int total = _storage.getInt(StorageService.totalDays) ?? 0;

    if (lastDate != null) {
      final lastParsed = DateTime.parse(lastDate);
      final todayParsed = DateTime.parse(today);
      final diff = todayParsed.difference(lastParsed).inDays;

      if (diff == 1) {
        current++;
      } else if (diff > 1) {
        current = 1;
      }
    } else {
      current = 1;
    }

    total++;
    if (current > longest) longest = current;

    await _storage.setString('streak_last_date', today);
    await _storage.setInt(StorageService.currentStreak, current);
    await _storage.setInt(StorageService.longestStreak, longest);
    await _storage.setInt(StorageService.totalDays, total);
  }

  UserStats getStats() {
    return UserStats(
      currentStreak: _storage.getInt(StorageService.currentStreak) ?? 0,
      longestStreak: _storage.getInt(StorageService.longestStreak) ?? 0,
      totalDays: _storage.getInt(StorageService.totalDays) ?? 0,
    );
  }

  // ─── Daily Entries ───

  List<DailyEntry> getEntries() {
    final jsonList = _storage.getJsonList(StorageService.dailyEntries);
    if (jsonList == null) return [];
    return jsonList.map((j) => DailyEntry.fromJson(j)).toList();
  }

  Future<void> addEntry(DailyEntry entry) async {
    final entries = getEntries();
    entries.add(entry);
    await _storage.setJsonList(
      StorageService.dailyEntries,
      entries.map((e) => e.toJson()).toList(),
    );
  }

  Map<String, bool> getCompletionMap() {
    final entries = getEntries();
    final map = <String, bool>{};
    for (final entry in entries) {
      final key =
          '${entry.date.year}-${entry.date.month.toString().padLeft(2, '0')}-${entry.date.day.toString().padLeft(2, '0')}';
      map[key] = entry.completed;
    }
    return map;
  }
}
