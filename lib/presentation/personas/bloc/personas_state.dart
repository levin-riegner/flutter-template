import 'package:color_picker/data/personas/model/persona.dart';
import 'package:color_picker/presentation/personas/bloc/personas_error.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personas_state.freezed.dart';

@freezed
sealed class PersonalitiesState with _$PersonalitiesState {
  const factory PersonalitiesState.personas({
    required DataState<List<Persona>, PersonalitiesError> data,
    String? selectedId,
  }) = _Personas;
}
