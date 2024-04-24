import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/model/forgot_password_request/forgot_password_request_request_model.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/presentation/auth/change_password/request/bloc/change_password_request_error.dart';
import 'package:flutter_template/presentation/auth/change_password/request/bloc/change_password_request_state.dart';
import 'package:flutter_template/util/mixins/resettable_bloc_mixin.dart';

class ChangePasswordRequestCubit extends Cubit<ChangePasswordRequestState>
    with ResettableBlocMixin {
  final AuthRepository _authRepository;

  ChangePasswordRequestCubit(this._authRepository)
      : super(ChangePasswordRequestState.empty());

  @override
  void resetState() {
    emit(
      ChangePasswordRequestStateInitial(
        email: state.email,
      ),
    );
  }

  void setEmail(String email) {
    emit(
      state.copyWith(email: email),
    );
  }

  Future<void> sendCodeToEmail() async {
    try {
      emit(
        ChangePasswordRequestStateLoading(
          email: state.email,
        ),
      );

      final request = ForgotPasswordRequestRequestModel(
        email: state.email,
      );

      await _authRepository.sendForgotPasswordRequest(
        request,
      );
    } on AuthDataError catch (error) {
      emit(
        ChangePasswordRequestStateError(
          error: ChangePasswordRequestDataError(
            error: error,
          ),
          email: state.email,
        ),
      );
    } catch (e) {
      emit(
        ChangePasswordRequestStateError(
          error: ChangePasswordRequestUnknownError(
            error: e.toString(),
          ),
          email: state.email,
        ),
      );
    }
  }
}
