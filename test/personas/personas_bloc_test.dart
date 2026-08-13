import 'package:bloc_test/bloc_test.dart';
import 'package:color_picker/data/personas/model/persona.dart';
import 'package:color_picker/data/personas/repository/personas_repository.dart';
import 'package:color_picker/presentation/personas/bloc/personas_bloc.dart';
import 'package:color_picker/presentation/personas/bloc/personas_error.dart';
import 'package:color_picker/presentation/personas/bloc/personas_event.dart';
import 'package:color_picker/presentation/personas/bloc/personas_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements PersonalitiesRepository {}

void main() {
  group('PersonalitiesBloc', () {
    late _MockRepository mockRepository;
    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    group('PersonalitiesEvent.load', () {
      blocTest<PersonalitiesBloc, PersonalitiesState>(
        'should emit loading then success with personas',
        setUp: () => when(() => mockRepository.getAll()).thenAnswer(
            (_) async => const [
          Persona(
            id: 'expert',
            name: 'Expert',
            description: 'Deep answers',
            systemPrompt: 'Be an expert.',
            iconName: 'science',
          ),
          Persona(
            id: 'teacher',
            name: 'Teacher',
            description: 'Tutor',
            systemPrompt: 'Teach clearly.',
            iconName: 'school',
          ),
        ]),
        build: () => PersonalitiesBloc(mockRepository),
        act: (bloc) => bloc.add(const PersonalitiesEvent.load()),
        expect: () => [
          const PersonalitiesState.personas(data: DataState.loading()),
          const PersonalitiesState.personas(
            data: DataState.success(data: [
              Persona(
                id: 'expert',
                name: 'Expert',
                description: 'Deep answers',
                systemPrompt: 'Be an expert.',
                iconName: 'science',
              ),
              Persona(
                id: 'teacher',
                name: 'Teacher',
                description: 'Tutor',
                systemPrompt: 'Teach clearly.',
                iconName: 'school',
              ),
            ]),
          ),
        ],
      );

      blocTest<PersonalitiesBloc, PersonalitiesState>(
        'should emit failure when loading throws',
        setUp: () => when(() => mockRepository.getAll())
            .thenThrow(Exception('boom')),
        build: () => PersonalitiesBloc(mockRepository),
        act: (bloc) => bloc.add(const PersonalitiesEvent.load()),
        skip: 1,
        expect: () => [
          PersonalitiesState.personas(
            data: DataState.failure(
              reason: PersonalitiesError.unknown(reason: 'Exception: boom'),
            ),
          ),
        ],
      );
    });

    group('PersonalitiesEvent.select', () {
      blocTest<PersonalitiesBloc, PersonalitiesState>(
        'should update the selectedId',
        build: () => PersonalitiesBloc(mockRepository),
        act: (bloc) => bloc.add(const PersonalitiesEvent.select(id: 'expert')),
        expect: () => [
          const PersonalitiesState.personas(
            data: DataState.success(data: <Persona>[]),
            selectedId: 'expert',
          ),
        ],
      );
    });
  });
}
