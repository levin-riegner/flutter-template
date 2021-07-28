abstract class Routes {
  const Routes._();

  // TODO: Add all new routes here
  // Articles
  static const articles = '/articles';
  static String articleDetails(String id) => "/$id"; 

  // Console
  static const console = "/console";
  static const environments = "console-environments";
  static const logins = "console-logins";
  static const qaConfigs = "console-qa-configs";
}
