import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/data/study_tutor/repository/study_tutor_repository.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_error.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_event.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class StudyTutorBloc extends Bloc<StudyTutorEvent, StudyTutorState> {
  final StudyTutorRepository _repository;

  StudyTutorBloc(this._repository)
      : super(const StudyTutorState.tutoring(
          session: DataState.idle(),
          dialogue: [],
          isAsking: false,
        )) {
    on<StudyTutorEvent>((event, emit) async {
      await event.when(
        startTutoring: (deckName) => _startTutoring(emit, deckName),
        ask: (question) => _ask(emit, question),
      );
    });
  }

  Future<void> _startTutoring(
    Emitter<StudyTutorState> emit,
    String deckName,
  ) async {
    emit(StudyTutorState.tutoring(
      session: DataState.loading(),
      dialogue: const [],
      isAsking: false,
    ));
    try {
      final session = await _repository.startTutorSession(deckName);
      emit(StudyTutorState.tutoring(
        session: DataState.success(data: session),
        dialogue: [session.welcome],
        isAsking: false,
      ));
    } catch (e) {
      Flogger.w("Failed to start tutoring: $e");
      emit(StudyTutorState.tutoring(
        session: DataState.failure(
          reason: StudyTutorError.unknown(reason: e.toString()),
        ),
        dialogue: const [],
        isAsking: false,
      ));
    }
  }

  Future<void> _ask(Emitter<StudyTutorState> emit, String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final current = state.dialogue;
    emit(StudyTutorState.tutoring(
      session: state.session,
      dialogue: [...current, trimmed],
      isAsking: true,
    ));
    try {
      final messages = await _repository.ask(trimmed);
      final reply = _lastAssistantMessage(messages);
      emit(StudyTutorState.tutoring(
        session: state.session,
        dialogue: [...state.dialogue, reply ?? ''],
        isAsking: false,
      ));
    } catch (e) {
      Flogger.w("Tutor reply failed: $e");
      emit(StudyTutorState.tutoring(
        session: state.session,
        dialogue: [...state.dialogue, ''],
        isAsking: false,
      ));
    }
  }

  String? _lastAssistantMessage(List<ChatMessage> messages) {
    for (final message in messages.reversed) {
      if (message.role == ChatRole.assistant) {
        return message.content;
      }
    }
    return null;
  }
}
