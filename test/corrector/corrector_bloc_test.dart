import 'package:bloc_test/bloc_test.dart';
import 'package:swiss_ai/data/corrector/model/correction.dart';
import 'package:swiss_ai/data/corrector/repository/corrector_repository.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_bloc.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_error.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_event.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements CorrectorRepository {}

void main() {
  group('CorrectorBloc', () {
    late _MockRepository mockRepository;
    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    blocTest<CorrectorBloc, CorrectorState>(
      'should emit loading then success with correction',
      setUp: () => when(() => mockRepository.correct(any())).thenAnswer(
        (_) async => Correction(
          original: "teh",
          corrected: "the",
          fixes: const [
            Fix(index: 0, replacement: "the", reason: "Fixed common typo"),
          ],
        ),
      ),
      build: () => CorrectorBloc(mockRepository),
      act: (bloc) => bloc.add(const CorrectorEvent.correct(content: "teh")),
      expect: () => [
        const CorrectorState.correct(data: DataState.loading(), isCorrecting: true),
        CorrectorState.correct(
          data: DataState.success(
            data: Correction(
              original: "teh",
              corrected: "the",
              fixes: const [
                Fix(index: 0, replacement: "the", reason: "Fixed common typo"),
              ],
            ),
          ),
          isCorrecting: false,
        ),
      ],
    );

    blocTest<CorrectorBloc, CorrectorState>(
      'should emit failure when repository throws',
      setUp: () => when(() => mockRepository.correct(any()))
          .thenThrow(Exception("boom")),
      build: () => CorrectorBloc(mockRepository),
      act: (bloc) => bloc.add(const CorrectorEvent.correct(content: "teh")),
      skip: 1,
      expect: () => [
        CorrectorState.correct(
          data: DataState.failure(
            reason: CorrectorError.unknown(reason: "Exception: boom"),
          ),
          isCorrecting: false,
        ),
      ],
    );

    blocTest<CorrectorBloc, CorrectorState>(
      'should emit emptyInput failure for blank content',
      build: () => CorrectorBloc(mockRepository),
      act: (bloc) => bloc.add(const CorrectorEvent.correct(content: "   ")),
      expect: () => [
        const CorrectorState.correct(
          data: DataState.failure(reason: CorrectorError.emptyInput()),
          isCorrecting: false,
        ),
      ],
    );
  });
}
