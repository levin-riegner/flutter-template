abstract class AuthEndpoints {
  static const String userRegister =
      "/actions/craft-cognito-auth/auth/register";
  static const String userUpdate = "/actions/craft-cognito-auth/auth/update";
  static const String userDelete = "/actions/craft-cognito-auth/auth/delete";
  static const String userDisable = "/actions/craft-cognito-auth/auth/disable";
  static const String userConfirm = "/actions/craft-cognito-auth/auth/confirm";
  static const String userLogin = "/actions/craft-cognito-auth/auth/login";
  static const String userRefreshToken =
      "/actions/craft-cognito-auth/auth/refresh";
  static const String userForgotPasswordRequest =
      "/actions/craft-cognito-auth/auth/forgotpasswordrequest";
  static const String userForgotPasswordConfirm =
      "/actions/craft-cognito-auth/auth/forgotpassword";
}

abstract class Endpoints {
  static const String articles = "/everything";
}
