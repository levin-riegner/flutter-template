import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/data/auth/service/remote/model/create_account/create_account_request_model.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_error.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final AuthRepository _authRepository;

  CreateAccountCubit(this._authRepository)
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
  void onChange(Change<CreateAccountState> change) {
    // TODO: Add Analytics and logging here
    super.onChange(change);
  }

  void setEmail(String email) {
    if (state is CreateAccountStateInitial) {
      emit(
        (state as CreateAccountStateInitial).copyWith(email: email),
      );
    }
  }

  void setPassword(String password) {
    if (state is CreateAccountStateInitial) {
      emit(
        (state as CreateAccountStateInitial).copyWith(password: password),
      );
    }
  }

  void setConfirmPassword(String confirmPassword) {
    if (state is CreateAccountStateInitial) {
      emit(
        (state as CreateAccountStateInitial)
            .copyWith(confirmPassword: confirmPassword),
      );
    }
  }

  void setFirstName(String firstName) {
    if (state is CreateAccountStateInitial) {
      emit(
        (state as CreateAccountStateInitial).copyWith(firstName: firstName),
      );
    }
  }

  void setLastName(String lastName) {
    if (state is CreateAccountStateInitial) {
      emit(
        (state as CreateAccountStateInitial).copyWith(lastName: lastName),
      );
    }
  }

  void setTermsAndConditionsAccepted(bool termsAndConditionsAccepted) {
    if (state is CreateAccountStateInitial) {
      emit(
        (state as CreateAccountStateInitial)
            .copyWith(termsAndConditionsAccepted: termsAndConditionsAccepted),
      );
    }
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

      final result = await _authRepository.createAccountWithEmailAndPassword(
        request,
      );

      await _authRepository.saveUserEmail(email);

      emit(
        CreateAccountStateSuccess(
          data: result,
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
