import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/data/chat/repository/chat_repository.dart';
import 'package:color_picker/presentation/chat/bloc/chat_bloc.dart';
import 'package:color_picker/presentation/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements ChatRepository {}

void main() {
  group('ChatPage', () {
    late _MockRepository mockRepository;

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    testWidgets('renders the message input and empty state', (tester) async {
      final bloc = ChatBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ChatPage(bloc: bloc))),
      );

      expect(find.text('Message the model...'), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('sends a message and shows a user bubble', (tester) async {
      when(() => mockRepository.sendMessage(any())).thenAnswer(
        (_) async => [
          const ChatMessage(
            id: '1',
            role: ChatRole.user,
            content: 'Hello model',
          ),
        ],
      );

      final bloc = ChatBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ChatPage(bloc: bloc))),
      );

      await tester.enterText(find.byType(TextField), 'Hello model');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      expect(find.text('Hello model'), findsOneWidget);
    });
  });
}
