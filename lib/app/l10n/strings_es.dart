// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'strings.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class StringsEs extends Strings {
  StringsEs([String locale = 'es']) : super(locale);

  @override
  String get dialogAppUpdateTitle => 'Update Available';

  @override
  String get dialogAppUpdateDescription =>
      'A new version of fluttertemplate is available. Please update now.';

  @override
  String get dialogAppUpdateConfirmationButton => 'Update';

  @override
  String get dialogAppUpdateDismissButton => 'Not Now';

  @override
  String get defaultErrorMessage =>
      'Woops something went wrong, please try again later.';

  @override
  String get defaultErrorPageDescription => 'Let\'s help get you back';

  @override
  String get defaultEmptyPageTitle => 'Nothing to see here';

  @override
  String get defaultEmptyPageDescription =>
      'It seems this page has no content...';

  @override
  String get defaultNoInternetPageTitle => 'Whoops!';

  @override
  String get defaultNoInternetPageDescription =>
      'Slow or no internet connection.\nPlease check your internet settings.';

  @override
  String get error => 'Error';

  @override
  String get refresh => 'Refresh';

  @override
  String get back => 'Go Back';

  @override
  String get networkErrorNotFound => 'Not found';

  @override
  String get networkErrorNoInternet =>
      'No Internet Connection\nPlease check your internet settings.';

  @override
  String get networkErrorBadInternet =>
      'Slow or no internet connection\nPlease check your connection and try again.';

  @override
  String get networkErrorServerTimeout =>
      'The server is taking too long to respond.\nPlease try again later.';

  @override
  String get networkErrorBadCertificate =>
      'The server certificate is invalid.\nPlease try again later.';

  @override
  String get loggedOutAlertTitle => 'You have been logged out';

  @override
  String get loggedOutAlertDescription =>
      'Please login again with your credentials';

  @override
  String get alertMessagePushNotificationPermanentlyDenied =>
      'Push notifications disabled. You can always enable them in your device settings.';

  @override
  String get openSettingsButton => 'Open Settings';

  @override
  String get pushNotificationDeeplinkButton => 'View';

  @override
  String get passwordField => 'Password';

  @override
  String get profileLegalLicenses => 'Third Party Notices';
}
