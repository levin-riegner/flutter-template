import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/model/user_confirm/user_confirm_request_model.dart';
import 'package:flutter_template/data/auth/model/user_confirm_request/user_confirm_request_request_model.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/data/user/repository/user_repository.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_cubit.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_error.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_state.dart';

class UserConfirmCubit extends OtpVerificationCubit {
  UserConfirmCubit(
    AuthRepository authRepository,
    UserRepository userRepository,
  ) : super(
          OtpVerificationState.empty(),
          authRepository: authRepository,
          userRepository: userRepository,
        );

  @override
  void resetState() {
    emit(
      OtpVerificationStateInitial(
        code: state.code,
        email: state.email,
        resendSuccesful: state.resendSuccesful,
      ),
    );
  }

  @override
  Future<void> sendCodeToEmail() async {
    try {
      await retrieveUserEmail();

      await authRepository.sendConfirmUserRequest(
        UserConfirmRequestRequestModel(
          email: state.email,
        ),
      );
    } on AuthDataError catch (error) {
      emit(
        OtpVerificationStateError(
          error: OtpVerificationDataError(
            error: error,
          ),
          email: state.email,
          code: state.code,
        ),
      );
    } catch (e) {
      emit(
        OtpVerificationStateError(
          error: OtpVerificationUnknownError(
            error: e.toString(),
          ),
          email: state.email,
          code: state.code,
        ),
      );
    }
  }

  void setCode(String code) {
    emit(
      state.copyWith(code: code),
    );
  }

  Future<void> retrieveUserEmail() async {
    final userEmail = await userRepository.userEmail;

    emit(
      state.copyWith(email: userEmail),
    );
  }

  Future<void> verifyCode(String code) async {
    try {
      await retrieveUserEmail();

      emit(
        OtpVerificationStateLoading(
          code: code,
          email: state.email,
        ),
      );

      final request = UserConfirmRequestModel(
        code: code,
        email: state.email,
      );

      final result = await authRepository.confirmUser(request);

      emit(
        OtpVerificationStateSuccess(
          data: result,
          email: state.email,
          code: code,
        ),
      );
    } on AuthDataError catch (error) {
      emit(
        OtpVerificationStateError(
          error: OtpVerificationDataError(
            error: error,
          ),
          email: state.email,
          code: code,
        ),
      );
    } catch (e) {
      emit(
        OtpVerificationStateError(
          error: OtpVerificationUnknownError(
            error: e.toString(),
          ),
          email: state.email,
          code: code,
        ),
      );
    }
  }
}
