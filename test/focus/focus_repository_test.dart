import 'package:swiss_ai/data/focus/repository/focus_repository.dart';
import 'package:swiss_ai/data/focus/service/local/focus_db_service.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('FocusRepository', () {
    late FocusDbService dbService;
    late DateTime now;
    late FocusRepository repository;

    setUp(() {
      dbService = FocusDbService();
      now = DateTime(2026, 1, 1, 12, 0, 0);
      repository = FocusRepository(dbService, clock: () => now);
    });

    test('createSession adds a paused session with zero elapsed', () async {
      final session =
          await repository.createSession('Deep work', durationSeconds: 600);
      assert(session.elapsedSeconds == 0);
      assert(!session.isRunning);
      assert(session.durationSeconds == 600);
      assert(session.remainingSeconds == 600);
    });

    test('startSession then tick advances elapsed by the clock delta', () async {
      final session =
          await repository.createSession('Deep work', durationSeconds: 600);
      await repository.startSession(session.id);
      // 90 seconds later.
      now = now.add(const Duration(seconds: 90));
      final running = await repository.tick();
      assert(running != null);
      final advanced = running!;
      assert(advanced.elapsedSeconds == 90);
      assert(advanced.remainingSeconds == 510);
      assert(advanced.progress > 0.0 && advanced.progress < 1.0);
    });

    test('tick does not complete before the duration elapses', () async {
      final session =
          await repository.createSession('Focus', durationSeconds: 100);
      await repository.startSession(session.id);
      now = now.add(const Duration(seconds: 50));
      final running = await repository.tick();
      assert(running != null);
      assert(!running!.isComplete);
    });

    test('tick completes the session when elapsed reaches duration', () async {
      final session =
          await repository.createSession('Short', durationSeconds: 30);
      await repository.startSession(session.id);
      now = now.add(const Duration(seconds: 45));
      final running = await repository.tick();
      assert(running != null);
      assert(running!.isComplete);
      assert(running!.remainingSeconds == 0);
      assert(running!.progress == 1.0);
    });

    test('pause stops advancing', () async {
      final session =
          await repository.createSession('Deep work', durationSeconds: 600);
      await repository.startSession(session.id);
      now = now.add(const Duration(seconds: 60));
      await repository.tick();
      await repository.pause();
      // Advance the clock; a paused session must stay put.
      now = now.add(const Duration(seconds: 300));
      final after = await repository.tick();
      assert(after == null); // nothing running, so no advance.
      final sessions = await repository.getSessions();
      assert(sessions.first.elapsedSeconds == 60);
      assert(!sessions.first.isRunning);
    });
  });
}
