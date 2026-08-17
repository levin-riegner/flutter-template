import 'package:swiss_ai/data/hf_model/model/hf_model.dart';
import 'package:swiss_ai/data/hf_model/repository/hf_model_repository.dart';
import 'package:swiss_ai/presentation/hf_model/bloc/hf_model_error.dart';
import 'package:swiss_ai/presentation/hf_model/bloc/hf_model_event.dart';
import 'package:swiss_ai/presentation/hf_model/bloc/hf_model_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class HfModelBloc extends Bloc<HfModelEvent, HfModelState> {
  final HfModelRepository _repository;

  HfModelBloc(this._repository)
      : super(const HfModelState.models(
          data: DataState.success(data: []),
          isLoading: false,
        )) {
    on<HfModelEvent>((event, emit) async {
      await event.when(
        refresh: () => _refresh(emit),
        select: (modelId) => _select(emit, modelId),
        clear: () => _clear(emit),
      );
    });
  }

  Future<void> _refresh(Emitter<HfModelState> emit) async {
    emit(const HfModelState.models(
      data: DataState.loading(),
      isLoading: true,
    ));
    try {
      final models = await _repository.refreshShortlist();
      emit(HfModelState.models(
        data: DataState.success(data: models),
        isLoading: false,
      ));
    } catch (e) {
      Flogger.w("Error refreshing model shortlist: $e");
      emit(HfModelState.models(
        data: DataState.failure(reason: HfModelError.unknown(reason: e.toString())),
        isLoading: false,
      ));
    }
  }

  Future<void> _select(Emitter<HfModelState> emit, String modelId) async {
    final current = switch (state.data) {
      Success(:final data) => data,
      _ => const <HfModel>[],
    };
    emit(HfModelState.models(
      data: DataState.success(data: current),
      isLoading: false,
      selectedId: modelId,
    ));
  }

  Future<void> _clear(Emitter<HfModelState> emit) async {
    await _repository.getCachedModels();
    emit(const HfModelState.models(
      data: DataState.success(data: []),
      isLoading: false,
    ));
  }
}
