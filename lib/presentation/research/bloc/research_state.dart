import 'package:swiss_ai/data/research/model/research_report.dart';
import 'package:swiss_ai/presentation/research/bloc/research_error.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'research_state.freezed.dart';

@freezed
sealed class ResearchState with _$ResearchState {
  const factory ResearchState({
    required DataState<ResearchReport, ResearchError> data,
    @Default(false) bool isResearching,
    @Default('') String stage,
  }) = _ResearchState;
}
