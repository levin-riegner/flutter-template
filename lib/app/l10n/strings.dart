import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'strings_en.dart';
import 'strings_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of Strings
/// returned by `Strings.of(context)`.
///
/// Applications need to include `Strings.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/strings.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Strings.localizationsDelegates,
///   supportedLocales: Strings.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the Strings.supportedLocales
/// property.
abstract class Strings {
  Strings(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Strings? of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings);
  }

  static const LocalizationsDelegate<Strings> delegate = _StringsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// Title for the app update dialog
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get dialogAppUpdateTitle;

  /// Description for the app update dialog
  ///
  /// In en, this message translates to:
  /// **'A new version of fluttertemplate is available. Please update now.'**
  String get dialogAppUpdateDescription;

  /// Button to confirm the app update
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get dialogAppUpdateConfirmationButton;

  /// Button to dismiss the app update
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get dialogAppUpdateDismissButton;

  /// Default error text for an unknown error
  ///
  /// In en, this message translates to:
  /// **'Woops something went wrong, please try again later.'**
  String get defaultErrorMessage;

  /// Text for an unexpected error
  ///
  /// In en, this message translates to:
  /// **'Let\'s help get you back'**
  String get defaultErrorPageDescription;

  /// Text for an unexpected empty page
  ///
  /// In en, this message translates to:
  /// **'Nothing to see here'**
  String get defaultEmptyPageTitle;

  /// Text for an unexpected empty page
  ///
  /// In en, this message translates to:
  /// **'It seems this page has no content...'**
  String get defaultEmptyPageDescription;

  /// Text for a page that failed to load due to no internet connection
  ///
  /// In en, this message translates to:
  /// **'Whoops!'**
  String get defaultNoInternetPageTitle;

  /// Text for a page that failed to load due to no internet connection
  ///
  /// In en, this message translates to:
  /// **'Slow or no internet connection.\nPlease check your internet settings.'**
  String get defaultNoInternetPageDescription;

  /// Generic title for an error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Text for a button that refreshes the page
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Text for a button that takes the user back to the previous page
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get back;

  /// Error message for item not found on the server
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get networkErrorNotFound;

  /// Error message for no internet connection
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection\nPlease check your internet settings.'**
  String get networkErrorNoInternet;

  /// Error message for weak or limited internet connection
  ///
  /// In en, this message translates to:
  /// **'Slow or no internet connection\nPlease check your connection and try again.'**
  String get networkErrorBadInternet;

  /// Error message for when the server is overloaded
  ///
  /// In en, this message translates to:
  /// **'The server is taking too long to respond.\nPlease try again later.'**
  String get networkErrorServerTimeout;

  /// Error message caused by an incorrect server certificate
  ///
  /// In en, this message translates to:
  /// **'The server certificate is invalid.\nPlease try again later.'**
  String get networkErrorBadCertificate;

  /// Alert title for a forced logout
  ///
  /// In en, this message translates to:
  /// **'You have been logged out'**
  String get loggedOutAlertTitle;

  /// Alert description for a forced logout
  ///
  /// In en, this message translates to:
  /// **'Please login again with your credentials'**
  String get loggedOutAlertDescription;

  /// Alert message when push notifications are permanently disabled
  ///
  /// In en, this message translates to:
  /// **'Push notifications disabled. You can always enable them in your device settings.'**
  String get alertMessagePushNotificationPermanentlyDenied;

  /// Button to open the device's app settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettingsButton;

  /// Button to open a push notification deeplink when the app is foregrounded
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get pushNotificationDeeplinkButton;

  /// Label for a password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordField;

  /// Profile item that navigates to 3rd party licenses screen
  ///
  /// In en, this message translates to:
  /// **'Third Party Notices'**
  String get profileLegalLicenses;
}

class _StringsDelegate extends LocalizationsDelegate<Strings> {
  const _StringsDelegate();

  @override
  Future<Strings> load(Locale locale) {
    return SynchronousFuture<Strings>(lookupStrings(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_StringsDelegate old) => false;
}

Strings lookupStrings(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return StringsEn();
    case 'es':
      return StringsEs();
  }

  throw FlutterError(
      'Strings.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
