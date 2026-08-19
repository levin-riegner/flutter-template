import 'package:swiss_ai/data/research/repository/research_repository.dart';
import 'package:swiss_ai/presentation/research/bloc/research_error.dart';
import 'package:swiss_ai/presentation/research/bloc/research_event.dart';
import 'package:swiss_ai/presentation/research/bloc/research_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ResearchBloc extends Bloc<ResearchEvent, ResearchState> {
  final ResearchRepository _repository;
  bool _cancelled = false;

  ResearchBloc(this._repository)
      : super(const ResearchState(
          data: DataState.idle(),
        )) {
    on<ResearchEvent>((event, emit) async {
      await event.when(
        start: (question) => _start(emit, question),
        cancel: () async => _cancel(emit),
        reset: () async => _reset(emit),
      );
    });
  }

  void _reset(Emitter<ResearchState> emit) {
    _cancelled = false;
    emit(const ResearchState(data: DataState.idle()));
  }

  void _cancel(Emitter<ResearchState> emit) {
    _cancelled = true;
    emit(state.copyWith(
      isResearching: false,
      stage: '',
      data: const DataState.failure(reason: ResearchError.cancelled()),
    ));
  }

  Future<void> _start(Emitter<ResearchState> emit, String question) async {
    final q = question.trim();
    if (q.isEmpty) {
      emit(const ResearchState(
        data: DataState.failure(reason: ResearchError.emptyQuestion()),
      ));
      return;
    }
    _cancelled = false;
    emit(const ResearchState(
      data: DataState.loading(),
      isResearching: true,
      stage: 'Planning',
    ));
    try {
      final report = await _repository.research(
        q,
        progress: (stage) {
          if (!_cancelled) emit(state.copyWith(stage: stage));
          return null;
        },
      );
      if (_cancelled) {
        return;
      }
      emit(ResearchState(
        data: DataState.success(data: report),
        isResearching: false,
        stage: '',
      ));
    } catch (e) {
      if (_cancelled) {
        return;
      }
      Flogger.w('Deep research failed: $e');
      final reason = e.toString().contains('No web sources')
          ? const ResearchError.noSources()
          : ResearchError.unknown(reason: e.toString());
      emit(ResearchState(
        data: DataState.failure(reason: reason),
        isResearching: false,
        stage: '',
      ));
    }
  }
}
