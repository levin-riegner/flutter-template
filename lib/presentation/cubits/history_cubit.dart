import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/data/services/services.dart';

part 'history_cubit.freezed.dart';

@freezed
abstract class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default({}) Map<String, bool> completionMap,
    @Default(UserStats()) UserStats stats,
  }) = _HistoryState;
}

class HistoryCubit extends Cubit<HistoryState> {
  final DailyRoutineService _dailyRoutineService;

  HistoryCubit({
    required DailyRoutineService dailyRoutineService,
  })  : _dailyRoutineService = dailyRoutineService,
        super(const HistoryState());

  void load() {
    final completionMap = _dailyRoutineService.getCompletionMap();
    final stats = _dailyRoutineService.getStats();
    emit(state.copyWith(
      completionMap: completionMap,
      stats: stats,
    ));
  }
}
