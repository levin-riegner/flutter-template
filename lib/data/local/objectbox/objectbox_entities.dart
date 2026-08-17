import 'package:objectbox/objectbox.dart';

/// ObjectBox entities backing the on-device data layer.
///
/// These are mutable persistence records (one row per object). The
/// immutable presentation models ([Flashcard], [ChatMessage], [Persona])
/// map onto them via their `*DbService`.
///
/// [id] is the ObjectBox-assigned primary key; [uid] is the stable business
/// id used by the presentation layer.
@Entity()
class FlashcardEntity {
  int? id;
  late String uid;
  late String front;
  late String back;
  late String deckName;
  late DateTime dueAt;
  late int repetitions;

  FlashcardEntity({
    required this.uid,
    required this.front,
    required this.back,
    required this.deckName,
    required this.dueAt,
    required this.repetitions,
  }) {
    id = 0;
  }
}

/// One chat message. [role] is stored as [ChatRoleOrdinal] to keep the
/// entity enum-free.
class ChatRoleOrdinal {
  static const int system = 0;
  static const int user = 1;
  static const int assistant = 2;
  static const int tool = 3;
}

@Entity()
class ChatMessageEntity {
  int? id;
  late String uid;
  late int role;
  late String content;

  ChatMessageEntity({
    required this.uid,
    required this.role,
    required this.content,
  }) {
    id = 0;
  }
}

/// Single-row record: the id of the currently selected persona.
/// [row] is always 'selectedPersona'.
@Entity()
class SelectionEntity {
  int? id;
  late String row;
  late String value;

  SelectionEntity({required this.row, required this.value}) {
    id = 0;
  }
}

/// A focus / pomodoro session. [uid] is the presentation-layer id.
@Entity()
class FocusSessionEntity {
  int? id;
  late String uid;
  late String label;
  late int durationSeconds;
  late int elapsedSeconds;
  late bool isRunning;

  FocusSessionEntity({
    required this.uid,
    required this.label,
    required this.durationSeconds,
    required this.elapsedSeconds,
    required this.isRunning,
  }) {
    id = 0;
  }
}
