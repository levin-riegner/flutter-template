import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:swiss_ai/data/chat/model/chat_message.dart';
import 'package:swiss_ai/data/chat/service/local/chat_db_service.dart';
import 'package:swiss_ai/data/focus/service/local/focus_db_service.dart';
import 'package:swiss_ai/data/local/objectbox/app_objectbox.dart';
import 'package:swiss_ai/data/personas/service/local/personas_db_service.dart';
import 'package:swiss_ai/data/study/service/local/study_db_service.dart';

void main() {
  late Directory tmp;
  late AppObjectBox ob;

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('swiss_ai_objectbox_test');
    ob = await AppObjectBox.create(directory: tmp.path) as AppObjectBox;
  });

  tearDown(() async {
    await ob.close();
    tmp.delete(recursive: true);
  });

  test('study: cards persist across service instances (restart)', () async {
    final db1 = StudyDbService(objectBox: ob);
    expect(await db1.getFlashcards(), hasLength(4), reason: 'seeded deck');

    await db1.createFlashcard(
      front: 'Q',
      back: 'A',
      deckName: 'My Deck',
    );

    // Simulate an app restart: fresh service, same store.
    final db2 = StudyDbService(objectBox: ob);
    final cards = await db2.getFlashcards();
    expect(cards, hasLength(5));
    expect(cards.where((c) => c.deckName == 'My Deck'), hasLength(1));

    await db2.removeFlashcard(cards.firstWhere((c) => c.deckName == 'My Deck').id);
    final db3 = StudyDbService(objectBox: ob);
    expect(await db3.getFlashcards(), hasLength(4));
  });

  test('chat: messages persist and clear()', () async {
    final db1 = ChatDbService(objectBox: ob);
    await db1.saveMessage(
      ChatMessage(id: 'm1', role: ChatRole.user, content: 'hi'),
    );

    final db2 = ChatDbService(objectBox: ob);
    expect(await db2.getMessages(), hasLength(1));

    await db2.clear();
    final db3 = ChatDbService(objectBox: ob);
    expect(await db3.getMessages(), isEmpty);
  });

  test('personas: selected id persists across instances', () async {
    final db1 = PersonasDbService(objectBox: ob);
    expect(await db1.getSelectedId(), isNull);
    await db1.select('teacher');

    final db2 = PersonasDbService(objectBox: ob);
    expect(await db2.getSelectedId(), 'teacher');

    await db2.clearSelection();
    final db3 = PersonasDbService(objectBox: ob);
    expect(await db3.getSelectedId(), isNull);
  });

  test('focus: sessions persist across instances', () async {
    final db1 = FocusDbService(objectBox: ob);
    final id = await db1.createSession('Deep work', 25 * 60);
    await db1.setRunning(id, true);
    await db1.updateElapsed(id, 120);

    final db2 = FocusDbService(objectBox: ob);
    final sessions = await db2.getSessions();
    expect(sessions, hasLength(1));
    expect(sessions.single.label, 'Deep work');
    expect(sessions.single.isRunning, isTrue);
    expect(sessions.single.elapsedSeconds, 120);
  });

  test('no objectBox: in-memory behavior unchanged (seeded, no persistence)',
      () async {
    final db1 = StudyDbService();
    expect(await db1.getFlashcards(), hasLength(4));
    await db1.createFlashcard(front: 'x', back: 'y', deckName: 'D');
    expect(await db1.getFlashcards(), hasLength(5));

    // A fresh in-memory service has no memory of the previous one.
    final db2 = StudyDbService();
    expect(await db2.getFlashcards(), hasLength(4));
  });
}
