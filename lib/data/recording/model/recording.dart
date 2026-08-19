import 'package:equatable/equatable.dart';

/// A single captured recording (for example a meeting segment).
class Recording extends Equatable {
  final String id;
  final String title;
  final String? transcript;
  final DateTime capturedAt;
  final Duration? duration;

  const Recording({
    required this.id,
    required this.title,
    this.transcript,
    required this.capturedAt,
    this.duration,
  });

  @override
  List<Object?> get props => [id, title, transcript, capturedAt, duration];
}
