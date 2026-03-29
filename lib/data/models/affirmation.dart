import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:affirmup/data/models/affirmation_category.dart';

part 'affirmation.freezed.dart';
part 'affirmation.g.dart';

@freezed
abstract class Affirmation with _$Affirmation {
  const factory Affirmation({
    required String id,
    required String text,
    required AffirmationCategory category,
    @Default(false) bool isFavorite,
  }) = _Affirmation;

  factory Affirmation.fromJson(Map<String, dynamic> json) =>
      _$AffirmationFromJson(json);
}
