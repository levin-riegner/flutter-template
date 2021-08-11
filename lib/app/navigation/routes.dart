abstract class Routes {
  const Routes._();

  // TODO: Add all new routes here
  // Home
  static const home = "/";

  // Articles
  static const articles = 'articles';
  static String articleDetails(String id) => "/$id"; 

  // Settings
  static const String settings = "settings";
  static const String settingsDetails = "detail";

  // Console
  static const console = "console";
  static const environments = "console-environments";
  static const logins = "console-logins";
  static const qaConfigs = "console-qa-configs";
}
