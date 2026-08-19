import 'package:swiss_ai/data/focus/model/focus_session.dart';
import 'package:swiss_ai/presentation/focus/bloc/focus_error.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_state.freezed.dart';

@freezed
sealed class FocusState with _$FocusState {
  const factory FocusState.focus({
    required DataState<List<FocusSession>, FocusError> sessions,
    required String? activeSessionId,
  }) = _Focus;
}
