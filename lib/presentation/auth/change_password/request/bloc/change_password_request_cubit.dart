import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/data/auth/service/remote/model/forgot_password_request/forgot_password_request_request_model.dart';
import 'package:flutter_template/presentation/auth/change_password/request/bloc/change_password_request_error.dart';
import 'package:flutter_template/presentation/auth/change_password/request/bloc/change_password_request_state.dart';
import 'package:flutter_template/util/mixins/resettable_bloc_mixin.dart';

class ChangePasswordRequestCubit extends Cubit<ChangePasswordRequestState>
    with ResettableBlocMixin {
  final AuthRepository _authRepository;

  ChangePasswordRequestCubit(this._authRepository)
      : super(
          const ChangePasswordRequestStateInitial(
            email: "",
          ),
        );

  @override
  void resetState() {
    emit(
      ChangePasswordRequestStateInitial(
        email: state.email,
      ),
    );
  }

  @override
  void onChange(Change<ChangePasswordRequestState> change) {
    super.onChange(change);

    // TODO: Add Analytics and logging here
  }

  void setEmail(String email) {
    emit(
      state.copyWith(email: email),
    );
  }

  Future<void> sendCodeToEmail(String email) async {
    try {
      emit(
        ChangePasswordRequestStateLoading(
          email: email,
        ),
      );

      final request = ForgotPasswordRequestRequestModel(
        email: email,
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
          email: email,
        ),
      );
    } catch (e) {
      emit(
        ChangePasswordRequestStateError(
          error: ChangePasswordRequestUnknownError(
            error: e.toString(),
          ),
          email: email,
        ),
      );
    }
  }
}
