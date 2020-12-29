<!-- omit in toc -->
# Flutter Template

Flutter template Application to checkout for new projects.
<!-- omit in toc -->
# Table of Contents
- [Installation](#installation)
- [Features](#features)
  - [Fonts](#fonts)
  - [Images](#images)
  - [Navigation](#navigation)
  - [Localization](#localization)
    - [Translating Texts](#translating-texts)
    - [Adding new languages](#adding-new-languages)
    - [Using Localizable Strings](#using-localizable-strings)
  - [Accessibility](#accessibility)
  - [Theming](#theming)
  - [Analytics](#analytics)
  - [App Environments](#app-environments)
    - [Configuring Environments](#configuring-environments)
    - [Constants](#constants)
  - [Dependency Injection](#dependency-injection)
  - [Logging](#logging)
  - [Firebase](#firebase)
  - [TODO: Crashlytics](#todo-crashlytics)
  - [TODO: Build runner and helper libs](#todo-build-runner-and-helper-libs)
  - [TODO: Launch Screen](#todo-launch-screen)
  - [TODO: Secure Storage](#todo-secure-storage)
  - [TODO: Architecture](#todo-architecture)
  - [TODO: CI/CD Integration](#todo-cicd-integration)
  - [TODO: Notifications](#todo-notifications)
  - [TODO: QA Console](#todo-qa-console)
  - [TODO: Update to null-safety (when available)](#todo-update-to-null-safety-when-available)

## Installation

1. Click the `Use this template` button to create a new repository.
1. Checkout and open with Android Studio.
1. Find and rename all instances of `com.levinriegner` with the company name, including folders.
1. Find and rename all instances of `fluttertemplate` and `flutter_template` with the actual product name, including folders.

## Features

### Fonts
1. Add required fonts inside `assets/fonts/font_name`.
    > Ensure font file names do not contain spaces.
1. Modify the fonts section in `pubspec.yaml` to meet your requirements.

### Images
1. Drop files inside `assets/images/` folders.
    - 1x images belong inside the root folder.
    - 2x and 3x images have their own separate folder.
1. Add a new reference to the image inside `lib/app/resources/assets.dart`.
1. To access the image accross the app use `Assets.myImage`.

### Navigation
1. Add your application routes inside `lib/app/navigation/routes.dart` following URL conventions.
1. Add a new route case inside `lib/app/navigation/router.dart` to map a route to a given Widget and Transition.

- [ ] TODO: Review [Navigator 2.0](https://flutter.dev/docs/development/ui/navigation)
- [ ] TODO: Review Deeplinks

### Localization
This template uses `l10n` for localization and managing translations.

On every build, the arb files will auto-generate the corresponding .dart files to use in the project.

#### Translating Texts
- English is set as the default root language from which all others are translated.
- Add or update your texts inside `lib/app/l10n/app_en.arb`.
- Additional translation languages are available with the following convention: `lib/app/l10n/app_*.arb`.

#### Adding new languages

1. Create a new file named `app_languagecode.arb` inside the `lib/app/l10n/` folder.<br>
*Spanish example: `lib/app/l10n/app_es.arb`*.
    > *More information about language codes can be found [here](https://wiki.mozilla.org/L10n:Locale_Codes)*

2. Add the new locale inside the `Info.plist` on the iOS project as described [here](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#localizing-for-ios-updating-the-ios-app-bundle).


#### Using Localizable Strings
1. Import the auto-generated dart file with the following line: `import 'package:flutter_gen/gen_l10n/strings.dart';`.
1. Reference localizable strings using `Strings.of(context).yourString`.

### Accessibility
- [ ] Describe Best practices

### Theming
- Modify the file inside `assets/theme.json` to match your application's Theme.
- You can access the theme properties accross the project using `ThemeProvider.theme.type.property`.
> You can see more information around theming [on the plugin repository](https://github.com/levin-riegner/flutter-design-system).

### Analytics
- Firebase Analytics is available in the project for tracking events.
- An `Analytics` class wrapper is provided to support multiple Analytics services.
- Add all Events and Parameters inside `AnalyticsEvent` and `AnalyticsParameter`.
- Track events using `Analytics.trackEvent(name, parameters)`.

### App Environments
This project supports 2 environments:
1. **Staging**: For testing purposes (aka: QA).
1. **Production**: For appstore releases.

The environment setup can be found on:
- **Android**: project level `build.gradle`.
- **iOS**: Schemes & Configurations.
- **Flutter**: `main_yourenvironment.dart` entry files.

An additional **Mock** entry file `main_mock.dart` is available for testing and better prototyping.

> Android Studio Run Configurations are saved inside the .run/ folder

- [ ] TODO: QA Banner

#### Configuring Environments
1. Environment variables can be found at `lib/app/config/environment.dart`.
1. Each entry file declares its environment.
1. The `Dependencies` class loads all the dependencies for a given environment.

#### Constants
- A constants file is available at `lib/app/config/constants.dart` for any constants not related to the environments.
- WebView URLs can be found at `lib/app/config/webview_urls.dart`.

### Dependency Injection
- The project uses the service locator [get_it](https://pub.dev/packages/get_it) to register and provide dependencies through out the app.
- Dependecies can be registered using the `Dependencies` class found at `lib/util/dependencies.dart`.
- Dependencies are loaded on each entry file for a given environment.
- A `useMocks` flag is available to register mock or test dependencies.

### Logging
- The `Flogger` class is provided as a wrapper to log records to different listeners.
- Use it directly as `Flogger.level("Message")`.<br>
  *Example: Flogger.info("LaunchCompleted");*
- External log listeners are configured inside the `Dependencies` class.
    > Papertrail is already available on this template.

### Firebase
1. Create a new Firebase Project that will contain:
    - Android Staging App.
    - Android Production App.
    - iOS Staging App.
    - iOS Production App.
1. Replace the google services files on both Android and iOS projects.

### TODO: Crashlytics

### TODO: Build runner and helper libs
- Equatable
- BuiltValue
- Json Serializable
- Freezed?
- ... Sample Model example

### TODO: Launch Screen
Logo + Background color

### TODO: Secure Storage
- Hardcoded keys
- Dynamic Tokens

### TODO: Architecture
- Bloc Provider
- Bloc Example
- Rx Stream Example
- Repository Example
- Tests Example

### TODO: CI/CD Integration
- Build numbers
- Keystore / Match
- Add fastlane files
- Add workflows from central repository
- Document Release process
- Link Secret generation process

### TODO: Notifications

### TODO: QA Console
- [ ] Logs
- [ ] Default logins

### TODO: Update to null-safety (when available)