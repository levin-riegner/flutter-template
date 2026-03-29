import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_entry.freezed.dart';
part 'daily_entry.g.dart';

@freezed
abstract class DailyEntry with _$DailyEntry {
  const factory DailyEntry({
    required String id,
    required DateTime date,
    required String affirmationId,
    @Default(false) bool completed,
    @Default(false) bool voiceRecorded,
    String? reflection,
  }) = _DailyEntry;

  factory DailyEntry.fromJson(Map<String, dynamic> json) =>
      _$DailyEntryFromJson(json);
}
