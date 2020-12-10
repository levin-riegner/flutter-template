# Flutter Template

Flutter template Application to checkout for new projects.

## Installation

1. Click the `Use this template` button to create a new repository.
1. Checkout and open with Android Studio.
1. Find and rename all instances of `com.levinriegner` with the company name, including folders.
1. Find and rename all instances of `fluttertemplate` and `flutter_template` with the actual product name, including folders.

## Usage

### Fonts
1. Add required fonts inside `assets/fonts/font_name`.
    > Ensure font files names do not contain spaces.
1. Modify the fonts section in `pubspec.yaml` to meet your requirements.

### Images
1. Drop files inside `assets/images/` folders.
    - 1x images belong inside the root folder.
    - 2x and 3x images have their own separate folder.
1. Add a new reference to the image inside `app/resources/assets.dart`.
1. To access the image accross the app use `Assets.myImage`.

### Navigation
1. Add your application routes inside `app/navigation/routes.dart` following URL conventions.
1. Add a new route case inside `app/navigation/router.dart` to map a route to a given Widget and Transition.

*TODO: Review [Navigator 2.0](https://flutter.dev/docs/development/ui/navigation)*

*TODO: Review Deeplinks*

### Localization
This template uses `l10n` for localization and managing translations.

#### Adding and Updating Translations
- A default english localization file can be found inside `lib/app/l10n/app_en.arb`.

- Additional translation languages can be added in that folder following the naming convention `app_languagecode.arb`. 
    > *More information about language codes can be found [here](https://wiki.mozilla.org/L10n:Locale_Codes)*

- **IMPORTANT**: When adding new languages on the Flutter project, they also need to be added inside `Info.plist` on the iOS project as described [here](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#localizing-for-ios-updating-the-ios-app-bundle).

- On every build, the arb files will auto-generate the corresponding .dart files to use in the project.

#### Using Localizable Strings
- Import the auto-generated dart file with the following line: `import 'package:flutter_gen/gen_l10n/strings.dart';`.
- Reference localizable strings using `Strings.of(context).yourString`.

### TODO: Accessibility
*Describe Best practices*

### Theming
- Modify the file inside `assets/theme.json` to match your application's Theme.
- You can access the theme properties accross the project using `ThemeProvider.theme.type.property`.
- You can see more information around theming [on the plugin repository](https://github.com/levin-riegner/flutter-design-system).

### Analytics
- Firebase Analytics is available for tracking events.
- An `Analytics` class wrapper is provided to support multiple Analytics services.
- Add all Events and Parameters inside `AnalyticsEvent` and `AnalyticsParameter`.
- Track events using `Analytics.trackEvent(name, parameters)`.

### App Environments
This project supports 2 environments:
1. **QA**: For testing purposes (aka: Staging).
1. **Production**: For appstore releases.

### Firebase
1. Create a new Firebase Project that will contain:
    - Android QA App.
    - Android Production App.
    - iOS QA App.
    - iOS Production App.
1. Replace the google services files on both Android and iOS projects.

### TODO: CI/CD Integration
- Build numbers
- Keystore / Match
- Add fastlane files
- Add workflows from central repository
- Document Release process
- Link Secret generation process

### TODO: Build runner and helper libs
- Equatable
- BuiltValue
- Json Serializable
- ... Sample Model example

### TODO: QA Console

### TODO: Notifications

### TODO: Launch Screen
Logo + Background color

### TODO: Architecture
- Bloc Provider
- Bloc Example
- Rx Stream Example
- Repository Example
- Tests Example

### TODO: Crashlytics
