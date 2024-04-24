import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/data/auth/service/remote/model/create_account/create_account_request_model.dart';
import 'package:flutter_template/data/user/repository/user_repository.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_error.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_state.dart';
import 'package:flutter_template/util/mixins/resettable_bloc_mixin.dart';

class CreateAccountCubit extends Cubit<CreateAccountState>
    with ResettableBlocMixin {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  CreateAccountCubit(this._authRepository, this._userRepository)
      : super(
          const CreateAccountStateInitial(
            email: "",
            password: "",
            firstName: "",
            lastName: "",
            confirmPassword: "",
            termsAndConditionsAccepted: false,
          ),
        );

  @override
  void resetState() {
    emit(
      CreateAccountStateInitial(
        email: state.email,
        password: state.password,
        firstName: state.firstName,
        lastName: state.lastName,
        confirmPassword: state.confirmPassword,
        termsAndConditionsAccepted: state.termsAndConditionsAccepted,
      ),
    );
  }

  @override
  void onChange(Change<CreateAccountState> change) {
    super.onChange(change);

    // TODO: Add Analytics and logging here
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

  void setConfirmPassword(String confirmPassword) {
    emit(
      state.copyWith(confirmPassword: confirmPassword),
    );
  }

  void setFirstName(String firstName) {
    emit(
      state.copyWith(firstName: firstName),
    );
  }

  void setLastName(String lastName) {
    emit(
      state.copyWith(lastName: lastName),
    );
  }

  void setTermsAndConditionsAccepted(bool termsAndConditionsAccepted) {
    emit(
      state.copyWith(termsAndConditionsAccepted: termsAndConditionsAccepted),
    );
  }

  Future<void> createAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String confirmPassword,
    required bool termsAndConditionsAccepted,
  }) async {
    emit(
      CreateAccountStateLoading(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        confirmPassword: confirmPassword,
        termsAndConditionsAccepted: termsAndConditionsAccepted,
      ),
    );

    try {
      final request = CreateAccountRequestModel(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      final createAccountResult =
          await _authRepository.createAccountWithEmailAndPassword(
        request,
      );

      await _userRepository.saveUserEmail(email);

      emit(
        CreateAccountStateSuccess(
          createAccountData: createAccountResult,
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          confirmPassword: confirmPassword,
          termsAndConditionsAccepted: termsAndConditionsAccepted,
        ),
      );
    } on AuthDataError catch (error) {
      emit(
        CreateAccountStateError(
          error: CreateAccountDataError(
            error: error,
          ),
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          confirmPassword: confirmPassword,
          termsAndConditionsAccepted: termsAndConditionsAccepted,
        ),
      );
    } catch (e) {
      emit(
        CreateAccountStateError(
          error: CreateAccountUnknownError(
            error: e.toString(),
          ),
          firstName: firstName,
          lastName: lastName,
          confirmPassword: confirmPassword,
          email: email,
          password: password,
          termsAndConditionsAccepted: termsAndConditionsAccepted,
        ),
      );
    }
  }
}
