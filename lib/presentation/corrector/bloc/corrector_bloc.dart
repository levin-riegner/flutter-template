import 'package:swiss_ai/data/corrector/repository/corrector_repository.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_error.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_event.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class CorrectorBloc extends Bloc<CorrectorEvent, CorrectorState> {
  final CorrectorRepository _repository;

  CorrectorBloc(this._repository)
      : super(const CorrectorState.correct(
          data: DataState.idle(),
          isCorrecting: false,
        )) {
    on<CorrectorEvent>((event, emit) async {
      await event.when(
        correct: (content) => _correct(emit, content),
      );
    });
  }

  Future<void> _correct(Emitter<CorrectorState> emit, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      emit(const CorrectorState.correct(
        data: DataState.failure(reason: CorrectorError.emptyInput()),
        isCorrecting: false,
      ));
      return;
    }
    emit(const CorrectorState.correct(
      data: DataState.loading(),
      isCorrecting: true,
    ));
    try {
      final correction = await _repository.correct(content);
      emit(CorrectorState.correct(
        data: DataState.success(data: correction),
        isCorrecting: false,
      ));
    } catch (e) {
      Flogger.w("Error correcting text: $e");
      emit(CorrectorState.correct(
        data: DataState.failure(
          reason: CorrectorError.unknown(reason: e.toString()),
        ),
        isCorrecting: false,
      ));
    }
  }
}
