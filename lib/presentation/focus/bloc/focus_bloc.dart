import 'package:color_picker/data/focus/model/focus_session.dart';
import 'package:color_picker/data/focus/repository/focus_repository.dart';
import 'package:color_picker/presentation/focus/bloc/focus_error.dart';
import 'package:color_picker/presentation/focus/bloc/focus_event.dart';
import 'package:color_picker/presentation/focus/bloc/focus_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class FocusBloc extends Bloc<FocusEvent, FocusState> {
  final FocusRepository _repository;

  FocusBloc(this._repository)
      : super(const FocusState.focus(
          sessions: DataState.success(data: []),
          activeSessionId: null,
        )) {
    on<FocusEvent>((event, emit) async {
      await event.when(
        loadSessions: () => _loadSessions(emit),
        createSession: (label, durationSeconds) =>
            _createSession(emit, label, durationSeconds),
        start: (sessionId) => _start(emit, sessionId),
        pause: () => _pause(emit),
        tick: () => _tick(emit),
        clear: () => _clear(emit),
      );
    });
  }

  Future<void> _loadSessions(Emitter<FocusState> emit) async {
    try {
      final sessions = await _repository.getSessions();
      emit(FocusState.focus(
        sessions: DataState.success(data: sessions),
        activeSessionId: state.activeSessionId,
      ));
    } catch (e) {
      Flogger.w("Failed to load focus sessions: $e");
      emit(FocusState.focus(
        sessions: DataState.failure(
          reason: FocusError.unknown(reason: e.toString()),
        ),
        activeSessionId: null,
      ));
    }
  }

  Future<void> _createSession(
    Emitter<FocusState> emit,
    String label,
    int durationSeconds,
  ) async {
    final trimmed = label.trim();
    if (trimmed.isEmpty) {
      emit(FocusState.focus(
        sessions: DataState.failure(reason: FocusError.emptyLabel()),
        activeSessionId: state.activeSessionId,
      ));
      return;
    }
    try {
      await _repository.createSession(trimmed, durationSeconds: durationSeconds);
      final sessions = await _repository.getSessions();
      emit(FocusState.focus(
        sessions: DataState.success(data: sessions),
        activeSessionId: state.activeSessionId,
      ));
    } catch (e) {
      Flogger.w("Failed to create focus session: $e");
      emit(FocusState.focus(
        sessions: DataState.failure(
          reason: FocusError.unknown(reason: e.toString()),
        ),
        activeSessionId: state.activeSessionId,
      ));
    }
  }

  Future<void> _start(Emitter<FocusState> emit, String sessionId) async {
    try {
      await _repository.startSession(sessionId);
      emit(FocusState.focus(
        sessions: DataState.success(data: state.sessionsData),
        activeSessionId: sessionId,
      ));
    } catch (e) {
      Flogger.w("Failed to start focus session: $e");
      emit(FocusState.focus(
        sessions: DataState.failure(
          reason: FocusError.sessionNotFound(reason: e.toString()),
        ),
        activeSessionId: null,
      ));
    }
  }

  Future<void> _pause(Emitter<FocusState> emit) async {
    await _repository.pause();
    final sessions = await _repository.getSessions();
    emit(FocusState.focus(
      sessions: DataState.success(data: sessions),
      activeSessionId: null,
    ));
  }

  Future<void> _tick(Emitter<FocusState> emit) async {
    final activeSessionId = state.activeSessionId;
    if (activeSessionId == null) {
      return;
    }
    await _repository.tick();
    final sessions = await _repository.getSessions();
    emit(FocusState.focus(
      sessions: DataState.success(data: sessions),
      activeSessionId: activeSessionId,
    ));
  }

  Future<void> _clear(Emitter<FocusState> emit) async {
    await _repository.pause();
    emit(const FocusState.focus(
      sessions: DataState.success(data: []),
      activeSessionId: null,
    ));
  }
}

extension on FocusState {
  List<FocusSession> get sessionsData => switch (sessions) {
        Success(data: final data) => data,
        _ => const [],
      };
}
