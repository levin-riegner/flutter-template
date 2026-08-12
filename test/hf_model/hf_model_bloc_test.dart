import 'package:bloc_test/bloc_test.dart';
import 'package:color_picker/data/hf_model/model/hf_model.dart';
import 'package:color_picker/data/hf_model/repository/hf_model_repository.dart';
import 'package:color_picker/presentation/hf_model/bloc/hf_model_bloc.dart';
import 'package:color_picker/presentation/hf_model/bloc/hf_model_error.dart';
import 'package:color_picker/presentation/hf_model/bloc/hf_model_event.dart';
import 'package:color_picker/presentation/hf_model/bloc/hf_model_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements HfModelRepository {}

void main() {
  group('HfModelBloc', () {
    late _MockRepository mockRepository;
    const models = [
      HfModel(id: 'org/qwen2.5-1.5b', downloads: 10, license: 'Apache-2.0'),
      HfModel(id: 'org/gemma-2-2b', downloads: 8, license: 'Apache-2.0'),
    ];
    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
      when(() => mockRepository.getCachedModels()).thenAnswer((_) async => []);
    });

    blocTest<HfModelBloc, HfModelState>(
      'should emit loading then success with shortlist',
      setUp: () => when(() => mockRepository.refreshShortlist())
          .thenAnswer((_) async => models),
      build: () => HfModelBloc(mockRepository),
      act: (bloc) => bloc.add(const HfModelEvent.refresh()),
      expect: () => [
        const HfModelState.models(
            data: DataState.loading(), isLoading: true),
        HfModelState.models(
            data: DataState.success(data: models), isLoading: false),
      ],
    );

    blocTest<HfModelBloc, HfModelState>(
      'should emit failure when refresh throws',
      setUp: () => when(() => mockRepository.refreshShortlist())
          .thenThrow(Exception("boom")),
      build: () => HfModelBloc(mockRepository),
      act: (bloc) => bloc.add(const HfModelEvent.refresh()),
      skip: 1,
      expect: () => [
        HfModelState.models(
            data: DataState.failure(
                reason: HfModelError.unknown(reason: "Exception: boom")),
            isLoading: false),
      ],
    );

    blocTest<HfModelBloc, HfModelState>(
      'should select a model and record selectedId',
      setUp: () => when(() => mockRepository.refreshShortlist())
          .thenAnswer((_) async => models),
      build: () => HfModelBloc(mockRepository),
      act: (bloc) {
        bloc.add(const HfModelEvent.refresh());
        bloc.add(const HfModelEvent.select(modelId: 'org/qwen2.5-1.5b'));
      },
      skip: 2,
      expect: () => [
        HfModelState.models(
            data: DataState.success(data: models),
            isLoading: false,
            selectedId: 'org/qwen2.5-1.5b'),
      ],
    );
  });
}
