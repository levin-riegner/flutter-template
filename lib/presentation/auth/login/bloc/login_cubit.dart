import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/model/login/login_request_model.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/data/user/repository/user_repository.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_error.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_state.dart';
import 'package:flutter_template/util/extensions/string_extension.dart';
import 'package:flutter_template/util/mixins/resettable_bloc_mixin.dart';
import 'package:flutter_template/util/mixins/user_not_confirmed_interceptor.dart';

class LoginCubit extends Cubit<LoginState>
    with ResettableBlocMixin, UserNotConfirmedInterceptor {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  LoginCubit(
    this._authRepository,
    this._userRepository,
  ) : super(LoginState.empty());

  @override
  void resetState() {
    emit(
      LoginStateInitial(
        email: state.email,
        password: state.password,
      ),
    );
  }

  void setEmail(String email) {
    emit(
      state.copyWith(email: email),
    );
  }

  void setPassword(String password) {
    emit(
      state.copyWith(password: password),
    );
  }

  Future<void> performLogin() async {
    emit(
      LoginStateLoading(
        email: state.email,
        password: state.password,
      ),
    );

    try {
      final request = LoginRequestModel(
        email: state.email,
        password: state.password,
      );

      final result = await _authRepository.loginWithEmailAndPassword(request);

      if (result.token.isNullOrEmpty) {
        throw NotAuthorized();
      }

      await Future.wait([
        _userRepository.saveUserEmail(state.email),
        _authRepository.saveUserToken(result.token!),
      ]);

      emit(
        LoginStateSuccess(
          data: result,
          email: state.email,
          password: state.password,
        ),
      );
    } on AuthDataError catch (error) {
      emit(
        LoginStateError(
          error: LoginDataError(
            error: error,
          ),
          email: state.email,
          password: state.password,
        ),
      );

      if (error is UserNotConfirmedException) {
        onUserNotConfirmedException();
      }
    } catch (e) {
      emit(
        LoginStateError(
          error: LoginUnknownError(
            error: e.toString(),
          ),
          email: state.email,
          password: state.password,
        ),
      );
    }
  }
}
