import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:affirmup/data/models/affirmation_category.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0) int totalDays,
    AffirmationCategory? favoriteCategory,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
