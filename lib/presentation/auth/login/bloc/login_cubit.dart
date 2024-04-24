import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/model/login/login_request_model.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_error.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_state.dart';
import 'package:flutter_template/util/mixins/resettable_bloc_mixin.dart';

class LoginCubit extends Cubit<LoginState> with ResettableBlocMixin {
  final AuthRepository _authRepository;

  LoginCubit(
    this._authRepository,
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
