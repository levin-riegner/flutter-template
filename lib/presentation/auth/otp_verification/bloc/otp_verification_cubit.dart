import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/data/user/repository/user_repository.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_state.dart';
import 'package:flutter_template/util/mixins/resettable_bloc_mixin.dart';

abstract class OtpVerificationCubit extends Cubit<OtpVerificationState>
    with ResettableBlocMixin {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  OtpVerificationCubit(
    super.initialState, {
    required this.authRepository,
    required this.userRepository,
  });

  Future<void> sendCodeToEmail();
}
