import 'package:color_picker/data/study_tutor/model/tutor_session.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_error.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_tutor_state.freezed.dart';

@freezed
sealed class StudyTutorState with _$StudyTutorState {
  const factory StudyTutorState.tutoring({
    required DataState<TutorSession, StudyTutorError> session,
    required List<String> dialogue,
    required bool isAsking,
  }) = _Tutoring;
}
