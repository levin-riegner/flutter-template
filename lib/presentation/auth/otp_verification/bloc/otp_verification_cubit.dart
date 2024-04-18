import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_state.dart';

abstract class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  OtpVerificationCubit(super.initialState);

  Future<bool> sendCodeToEmail();
}
