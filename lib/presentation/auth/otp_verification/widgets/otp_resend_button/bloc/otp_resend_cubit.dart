import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/presentation/auth/otp_verification/widgets/otp_resend_button/bloc/otp_resend_state.dart';

class OtpResendCubit extends Cubit<OtpResendState> {
  final int countdownSeconds;
  Timer? _timer;

  OtpResendCubit({
    required this.countdownSeconds,
  }) : super(
          OtpResendStateInitial(
            countdownSeconds: countdownSeconds,
          ),
        );

  void start({
    required Future<void> Function() onResend,
    Function(Object)? onError,
  }) async {
    try {
      emit(const OtpResendStateLoading());

      await onResend();

      _timer?.cancel();

      emit(
        OtpResendStateStarted(
          countdownSeconds: countdownSeconds,
        ),
      );

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state.countdownSeconds > 1) {
          emit(
            OtpResendStateStarted(
              countdownSeconds: state.countdownSeconds - 1,
            ),
          );
        } else {
          timer.cancel();
          emit(const OtpResendStateFinished());
        }
      });
    } catch (e) {
      if (onError != null) {
        onError(e);
      }
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
