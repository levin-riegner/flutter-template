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
    - [Integrating 3rd party translation service](#integrating-3rd-party-translation-service)
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
  - [Crashlytics](#crashlytics)
  - [Models](#models)
    - [Domain Models](#domain-models)
    - [Data Models](#data-models)
    - [UI Models](#ui-models)
  - [TODO: Database](#todo-database)
  - [TODO: Network](#todo-network)
  - [TODO: Secure Storage](#todo-secure-storage)
  - [TODO: WebViews](#todo-webviews)
  - [TODO: Launch Screen](#todo-launch-screen)
  - [TODO: Architecture](#todo-architecture)
  - [TODO: Error Handling](#todo-error-handling)
  - [TODO: CI/CD Integration](#todo-cicd-integration)
  - [TODO: Notifications](#todo-notifications)
  - [TODO: QA Console](#todo-qa-console)
  - [TODO: Null-safety (when available)](#todo-null-safety-when-available)
  - [TODO: App Update](#todo-app-update)
  - [TODO: App Review](#todo-app-review)

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

> It is recommended you use the `Flutter Intl` plugin for Android Studio or VSCode.

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


#### Integrating 3rd party translation service
l10n for Flutter comes with support for [Localizely](https://localizely.com/) to hire a team of translators to manage the app's languages.

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
> More info about environment setup can be found [in this document](https://www.notion.so/App-Environments-01422cd3d1d74aec8fb8e4b3f4fd14fb).

An additional **Mock** entry file `main_mock.dart` is available for testing and better prototyping.

> Android Studio Run Configurations are available inside the .run/ folder

For internal environments (such as Staging) a Banner will be shown on the top end part of the screen to easily identify the app against the production version. This can be configured inside the `lib/app/app.dart` file.

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

### Crashlytics
Firebase Crashlytics is already added in the project.

It also uploads iOS dSYMS to Firebase as part of the Build Phases.

Logs recorded before the crash are sent as part of the crash report.

> Remember to enable Crashlytics for each app on your Firebase Project Dashboard

### Models
This project uses [build_runner](https://pub.dev/packages/build_runner) to auto-generate the necessary boilerplate for model classes. The plugins triggered by the build are:
- [Freezed](https://pub.dev/packages/freezed): Generates toString, equals and hashCode. Creates immutable classes.
- [Json Serializable](https://pub.dev/packages/json_serializable): Generates toJson/fromJson methods. *Included in the freezed plugin*.

> To execute the build runner use the following command: <br>
`flutter pub run build_runner build --delete-conflicting-outputs`.

> Currently on Flutter 1.22.* build_runner breaks with l10n, follow [this issue](https://github.com/dart-lang/build/issues/2835#issuecomment-703528119) instructions for the workaround.

#### Domain Models

- These clases model the app's data and are used to communicate between the UI and the Data layers.

- They are platform-agnostic and contain business logic.

- An example can be found at `lib/data/article/model/article.dart`.

#### Data Models

- Theses clases model the data for specific services (ex: a database or API).

- They need to be converted to domain models to communicate with the UI layer.

- An example can be found at `lib/data/article/services/remote/model/article_api_model.dart`.

#### UI Models

- These clases hold the current state of the UI.

- They are created and manipulated only on the Bloc and exposed for the View to listen.

- On simple views this class may be omitted and the Domain models exposed directly on the Bloc.

- An example can be found at `lib/presentation/articles/article_state.dart`.

- A generic `DataState` class can be found, which allows for data models to be extended with idle/loading/content/error methods to update the UI accordingly. 

### TODO: Database
https://pub.dev/packages/hive

### TODO: Network
https://newsapi.org/

### TODO: Secure Storage
- Hardcoded keys
- Dynamic Tokens

### TODO: WebViews

### TODO: Launch Screen
Logo + Background color

### TODO: Architecture
- [ ] Bloc Provider
- [ ] Bloc Example
- [ ] Rx Stream Example
- [ ] Repository Example
- [ ] Tests Example

### TODO: Error Handling

### TODO: CI/CD Integration
- [ ] Build numbers
- [ ] Keystore / Match
- [ ] Add fastlane files
- [ ] Add workflows from central repository
- [ ] Document Release process
- [ ] Link Secret generation process

### TODO: Notifications

### TODO: QA Console
- [ ] Logs
- [ ] Default logins
- [ ] Theme changer

### TODO: Null-safety (when available)

### TODO: App Update

### TODO: App Review
https://pub.dev/packages/in_app_review