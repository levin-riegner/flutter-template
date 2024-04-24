import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/model/forgot_password_confirm/forgot_password_confirm_request_model.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/presentation/auth/change_password/confirm/bloc/change_password_confirm_error.dart';
import 'package:flutter_template/presentation/auth/change_password/confirm/bloc/change_password_confirm_state.dart';
import 'package:flutter_template/util/extensions/string_extension.dart';
import 'package:flutter_template/util/mixins/resettable_bloc_mixin.dart';

class ChangePasswordConfirmCubit extends Cubit<ChangePasswordConfirmState>
    with ResettableBlocMixin {
  final AuthRepository _authRepository;

  ChangePasswordConfirmCubit(this._authRepository)
      : super(ChangePasswordConfirmState.empty());

  @override
  void resetState() {
    emit(
      ChangePasswordConfirmStateInitial(
        email: state.email,
        password: state.password,
        confirmPassword: state.confirmPassword,
        code: state.code,
      ),
    );
  }

  void setPassword(String password) {
    emit(
      state.copyWith(password: password),
    );
  }

  void setConfirmPassword(String confirmPassword) {
    emit(
      state.copyWith(confirmPassword: confirmPassword),
    );
  }

  void setCode(String code) {
    emit(
      state.copyWith(code: code),
    );
  }

  void setEmail(String? email) {
    if (!email.isNullOrEmpty) {
      emit(
        state.copyWith(email: email),
      );
    }
  }

  Future<void> changePassword() async {
    try {
      emit(
        ChangePasswordConfirmStateLoading(
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          code: state.code,
        ),
      );

      final request = ForgotPasswordConfirmRequestModel(
        code: state.code,
        email: state.email,
        password: state.password,
      );

      await _authRepository.confirmForgotPasswordRequest(request);
    } on AuthDataError catch (error) {
      emit(
        ChangePasswordConfirmStateError(
          error: ChangePasswordConfirmDataError(
            error: error,
          ),
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          code: state.code,
        ),
      );
    } catch (e) {
      emit(
        ChangePasswordConfirmStateError(
          error: ChangePasswordConfirmUnknownError(
            error: e.toString(),
          ),
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          code: state.code,
        ),
      );
    }
  }
}
