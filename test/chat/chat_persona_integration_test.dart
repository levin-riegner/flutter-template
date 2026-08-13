import 'package:color_picker/data/chat/repository/chat_repository.dart';
import 'package:color_picker/data/personas/model/persona.dart';
import 'package:color_picker/data/personas/repository/personas_repository.dart';
import 'package:color_picker/presentation/chat/bloc/chat_bloc.dart';
import 'package:color_picker/presentation/chat/bloc/chat_event.dart';
import 'package:test/scaffolding.dart';
import 'package:mocktail/mocktail.dart';

class _MockChatRepository extends Mock implements ChatRepository {}

class _MockPersonasRepository extends Mock implements PersonalitiesRepository {}

void main() {
  const teacher = Persona(
    id: 'teacher',
    name: 'Teacher',
    description: 'Explains clearly',
    systemPrompt: 'You are a patient teacher.',
    iconName: 'school',
  );

  group('ChatBloc <-> Personas integration', () {
    late _MockChatRepository mockChat;
    late _MockPersonasRepository mockPersonas;

    setUp(() {
      mockChat = _MockChatRepository();
      mockPersonas = _MockPersonasRepository();
      reset(mockChat);
      reset(mockPersonas);
      when(() => mockChat.sendMessage(any(), systemPrompt: any(named: 'systemPrompt')))
          .thenAnswer((_) async => []);
    });

    test('does not pass a system prompt when no persona is selected', () async {
      when(() => mockPersonas.getSelectedId()).thenAnswer((_) async => null);
      final bloc = ChatBloc(mockChat, mockPersonas);
      bloc.add(const ChatEvent.sendMessage(content: 'Hi'));
      await Future.delayed(const Duration(milliseconds: 100));
      verify(() => mockChat.sendMessage('Hi', systemPrompt: null)).called(1);
      await bloc.close();
    });

    test('passes the selected persona system prompt when one is active',
        () async {
      when(() => mockPersonas.getSelectedId())
          .thenAnswer((_) async => 'teacher');
      when(() => mockPersonas.getAll()).thenAnswer((_) async => [teacher]);
      final bloc = ChatBloc(mockChat, mockPersonas);
      bloc.add(const ChatEvent.sendMessage(content: 'Hi'));
      await Future.delayed(const Duration(milliseconds: 100));
      verify(() =>
              mockChat.sendMessage('Hi', systemPrompt: 'You are a patient teacher.'))
          .called(1);
      await bloc.close();
    });
  });
}
