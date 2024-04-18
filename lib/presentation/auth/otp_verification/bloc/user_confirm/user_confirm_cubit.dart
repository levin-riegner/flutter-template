import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_confirm/user_confirm_request_model.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_error.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/otp_verification_state.dart';

class UserConfirmCubit extends Cubit<OtpVerificationState> {
  final AuthRepository _authRepository;

  UserConfirmCubit(this._authRepository)
      : super(
          const OtpVerificationStateInitial(
            code: "",
            email: "",
          ),
        );

  @override
  void onChange(Change<OtpVerificationState> change) {
    // TODO: Add Analytics and logging here
    super.onChange(change);
  }

  void setCode(String code) {
    if (state is OtpVerificationStateInitial) {
      emit(
        (state as OtpVerificationStateInitial).copyWith(code: code),
      );
    }
  }

  void retrieveUserEmail() async {
    final userEmail = await _authRepository.userEmail;

    if (userEmail != null) {
      if (state is OtpVerificationStateInitial) {
        emit(
          (state as OtpVerificationStateInitial).copyWith(email: userEmail),
        );
      }
    }
  }

  Future<void> verifyCode(String code) async {
    emit(
      OtpVerificationStateLoading(
        code: code,
        email: state.email,
      ),
    );

    try {
      final request = UserConfirmRequestModel(
        code: code,
        email: state.email,
      );

      final result = await _authRepository.confirmUser(request);

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