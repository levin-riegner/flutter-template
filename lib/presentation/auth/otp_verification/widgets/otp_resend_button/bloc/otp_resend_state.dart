import 'package:equatable/equatable.dart';

sealed class OtpResendState extends Equatable {
  final int countdownSeconds;

  const OtpResendState({
    required this.countdownSeconds,
  });

  bool get isActive;
}

class OtpResendStateInitial extends OtpResendState {
  const OtpResendStateInitial({
    required super.countdownSeconds,
  });

  @override
  List<Object?> get props => [countdownSeconds, isActive];

  @override
  bool get isActive => false;
}

class OtpResendStateLoading extends OtpResendState {
  const OtpResendStateLoading({
    required super.countdownSeconds,
  });

  @override
  List<Object?> get props => [countdownSeconds, isActive];

  @override
  bool get isActive => false;
}

class OtpResendStateStarted extends OtpResendState {
  const OtpResendStateStarted({
    required super.countdownSeconds,
  });

  @override
  List<Object?> get props => [countdownSeconds, isActive];

  @override
  bool get isActive => true;
}

class OtpResendStateFinished extends OtpResendState {
  const OtpResendStateFinished()
      : super(
          countdownSeconds: 0,
        );

  @override
  List<Object?> get props => [countdownSeconds, isActive];

  @override
  bool get isActive => false;
}
