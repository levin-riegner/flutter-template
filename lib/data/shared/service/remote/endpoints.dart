abstract class AuthEndpoints {
  static const String userRegister = "/actions/craft-cognito/auth/register";
  static const String userUpdate = "/actions/craft-cognito/auth/update";
  static const String userDelete = "/actions/craft-cognito/auth/delete";
  static const String userDisable = "/actions/craft-cognito/auth/disable";
  static const String userConfirmRequest =
      "/actions/craft-cognito/auth/confirmrequest";
  static const String userConfirm = "/actions/craft-cognito/auth/confirm";
  static const String userLogin = "/actions/craft-cognito/auth/login";
  static const String userRefreshToken = "/actions/craft-cognito/auth/refresh";
  static const String userForgotPasswordRequest =
      "/actions/craft-cognito/auth/forgotpasswordrequest";
  static const String userForgotPasswordConfirm =
      "/actions/craft-cognito/auth/forgotpassword";
}

abstract class Endpoints {
  static const String articles = "/everything";
}
