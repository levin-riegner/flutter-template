import 'package:swiss_ai/data/personas/model/persona.dart';
import 'package:swiss_ai/data/personas/repository/personas_repository.dart';
import 'package:swiss_ai/presentation/personas/bloc/personas_error.dart';
import 'package:swiss_ai/presentation/personas/bloc/personas_event.dart';
import 'package:swiss_ai/presentation/personas/bloc/personas_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class PersonalitiesBloc extends Bloc<PersonalitiesEvent, PersonalitiesState> {
  final PersonalitiesRepository _repository;

  PersonalitiesBloc(this._repository)
      : super(const PersonalitiesState.personas(
          data: DataState.loading(),
        )) {
    on<PersonalitiesEvent>((event, emit) async {
      await event.when(
        load: () => _load(emit),
        select: (id) => _select(emit, id),
      );
    });
  }

  Future<void> _load(Emitter<PersonalitiesState> emit) async {
    emit(const PersonalitiesState.personas(data: DataState.loading()));
    try {
      final personas = await _repository.getAll();
      emit(PersonalitiesState.personas(
        data: DataState.success(data: personas),
      ));
    } catch (e) {
      Flogger.w("Error loading personas: $e");
      emit(PersonalitiesState.personas(
        data: DataState.failure(
          reason: PersonalitiesError.unknown(reason: e.toString()),
        ),
      ));
    }
  }

  Future<void> _select(Emitter<PersonalitiesState> emit, String id) async {
    final current = switch (state.data) {
      Success(:final data) => data,
      _ => const <Persona>[],
    };
    emit(PersonalitiesState.personas(
      data: DataState.success(data: current),
      selectedId: id,
    ));
  }
}
