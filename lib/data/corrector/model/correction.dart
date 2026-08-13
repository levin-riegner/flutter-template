import 'package:equatable/equatable.dart';

/// A single localized fix applied by the corrector.
///
/// [index] is the character offset in the original [Correction.original]
/// where the replacement should be applied.
class Fix extends Equatable {
  final int index;
  final String replacement;
  final String reason;

  const Fix({
    required this.index,
    required this.replacement,
    required this.reason,
  });

  @override
  List<Object?> get props => [index, replacement, reason];
}

/// The result of a local, on-device correction pass.
///
/// Kept as a plain immutable model so the corrector feature stays testable on
/// the host without native plugins or network access (same convention as the
/// chat feature).
class Correction extends Equatable {
  final String original;
  final String corrected;
  final List<Fix> fixes;

  const Correction({
    required this.original,
    required this.corrected,
    required this.fixes,
  });

  bool get hasChanges => fixes.isNotEmpty;

  @override
  List<Object?> get props => [original, corrected, fixes];
}
