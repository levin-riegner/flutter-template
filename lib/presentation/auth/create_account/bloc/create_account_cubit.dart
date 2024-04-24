import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/model/create_account/create_account_request_model.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_error.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_state.dart';
import 'package:flutter_template/util/mixins/resettable_bloc_mixin.dart';

class CreateAccountCubit extends Cubit<CreateAccountState>
    with ResettableBlocMixin {
  final AuthRepository _authRepository;

  CreateAccountCubit(this._authRepository) : super(CreateAccountState.empty());

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

  Future<void> createAccount() async {
    emit(
      CreateAccountStateLoading(
        email: state.email,
        password: state.password,
        firstName: state.firstName,
        lastName: state.lastName,
        confirmPassword: state.confirmPassword,
        termsAndConditionsAccepted: state.termsAndConditionsAccepted,
      ),
    );

    try {
      final request = CreateAccountRequestModel(
        email: state.email,
        password: state.password,
        firstName: state.firstName,
        lastName: state.lastName,
      );

      final createAccountResult =
          await _authRepository.createAccountWithEmailAndPassword(
        request,
      );

      emit(
        CreateAccountStateSuccess(
          createAccountData: createAccountResult,
          email: state.email,
          password: state.password,
          firstName: state.firstName,
          lastName: state.lastName,
          confirmPassword: state.confirmPassword,
          termsAndConditionsAccepted: state.termsAndConditionsAccepted,
        ),
      );
    } on AuthDataError catch (error) {
      emit(
        CreateAccountStateError(
          error: CreateAccountDataError(
            error: error,
          ),
          email: state.email,
          password: state.password,
          firstName: state.firstName,
          lastName: state.lastName,
          confirmPassword: state.confirmPassword,
          termsAndConditionsAccepted: state.termsAndConditionsAccepted,
        ),
      );
    } catch (e) {
      emit(
        CreateAccountStateError(
          error: CreateAccountUnknownError(
            error: e.toString(),
          ),
          firstName: state.firstName,
          lastName: state.lastName,
          confirmPassword: state.confirmPassword,
          email: state.email,
          password: state.password,
          termsAndConditionsAccepted: state.termsAndConditionsAccepted,
        ),
      );
    }
  }
}
