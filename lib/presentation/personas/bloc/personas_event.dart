import 'package:freezed_annotation/freezed_annotation.dart';

part 'personas_event.freezed.dart';

@freezed
sealed class PersonalitiesEvent with _$PersonalitiesEvent {
  const factory PersonalitiesEvent.load() = PersonalitiesEventLoad;

  const factory PersonalitiesEvent.select({required String id}) =
      PersonalitiesEventSelect;
}
