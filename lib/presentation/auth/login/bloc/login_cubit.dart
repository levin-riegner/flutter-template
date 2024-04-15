import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/data/auth/service/remote/model/login/login_request_model.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_error.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository)
      : super(
          const LoginStateInitial(email: "", password: ""),
        );

  @override
  void onChange(Change<LoginState> change) {
    // TODO: Add Analytics and logging here
    super.onChange(change);
  }

  void setEmail(String email) {
    if (state is LoginStateInitial) {
      emit(
        (state as LoginStateInitial).copyWith(email: email),
      );
    }
  }

  void setPassword(String password) {
    if (state is LoginStateInitial) {
      emit(
        (state as LoginStateInitial).copyWith(password: password),
      );
    }
  }

  Future<void> performLogin(String email, String password) async {
    emit(
      LoginStateLoading(
        email: email,
        password: password,
      ),
    );

    try {
      final request = LoginRequestModel(
        email: email,
        password: password,
      );

      final result = await _authRepository.loginWithEmailAndPassword(request);

      emit(
        LoginStateSuccess(
          data: result,
          email: email,
          password: password,
        ),
      );
    } on AuthDataError catch (error) {
      emit(
        LoginStateError(
          error: LoginDataError(
            error: error,
          ),
          email: email,
          password: password,
        ),
      );
    } catch (e) {
      emit(
        LoginStateError(
          error: LoginUnknownError(
            error: e.toString(),
          ),
          email: email,
          password: password,
        ),
      );
    }
  }
}
