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
    - [DTO Models](#dto-models)
    - [UI Models](#ui-models)
  - [Network](#network)
  - [Database](#database)
    - [Encryption](#encryption)
    - [TODO: Streams](#todo-streams)
  - [Secure Storage](#secure-storage)
  - [TODO: WebViews](#todo-webviews)
  - [TODO: No Internet Connection](#todo-no-internet-connection)
  - [TODO: Launch Screen](#todo-launch-screen)
  - [Architecture](#architecture)
    - [Bloc](#bloc)
    - [TODO: Repository Pattern](#todo-repository-pattern)
      - [TODO: Mocks](#todo-mocks)
    - [TODO: Error Handling](#todo-error-handling)
      - [TODO: One-Time Alerts](#todo-one-time-alerts)
  - [TODO: Tests](#todo-tests)
  - [TODO: App Dispose](#todo-app-dispose)
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
2. Add a new reference to the image to the [Assets](lib/app/resources/assets.dart) class.
3. To access the image accross the app use `Assets.myImage`.

### Navigation
1. Add your application routes inside the [Routes](lib/app/navigation/routes.dart) class following URL conventions.
1. Add a new route case inside `lib/app/navigation/router.dart` to map a route to a given Widget and Transition.

- [ ] Review [Navigator 2.0](https://flutter.dev/docs/development/ui/navigation)
- [ ] Review Deeplinks

### Localization
This template uses `l10n` for localization and managing translations.

> It is recommended you use the `Flutter Intl` plugin for Android Studio or VSCode.

On every build, the arb files will auto-generate the corresponding .dart files to use in the project.

#### Translating Texts
- English is set as the default root language from which all others are translated.
- Add or update your texts inside the [English arb file](lib/app/l10n/app_en.arb).
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
https://flutter.dev/docs/development/accessibility-and-localization/accessibility#accessibility-release-checklist 
- [ ] Describe Best practices

### Theming
- Modify the [Theme file](assets/theme.json) to match your application's Theme.
- You can access the theme properties accross the project using `ThemeProvider.theme.type.property`.
> You can see more information around theming [on the plugin repository](https://github.com/levin-riegner/flutter-design-system).

- [ ] Use with Provider

### Analytics
An [Analytics](lib/util/integrations/analytics.dart) class wrapper is provided to support multiple Analytics services.
1. Add all Events and Parameters inside `AnalyticsEvent` and `AnalyticsParameter`.
2. Track events using `Analytics.trackEvent(name, parameters)`.
  
Firebase Analytics is already installed in the project.

### App Environments
This project supports 2 environments:
1. **Staging**: For testing purposes (aka: QA).
1. **Production**: For appstore releases.

The environment setup can be found on:
- **Android**: project level [build.gradle](android/app/build.gradle).
- **iOS**: Schemes & Configurations.
- **Flutter**: `main_yourenvironment.dart` entry files.
> More info about environment setup can be found [in this document](https://www.notion.so/App-Environments-01422cd3d1d74aec8fb8e4b3f4fd14fb).

An additional **Mock** [entry file](lib/main_mock.dart) is available for testing and better prototyping.

> Android Studio Run Configurations are available inside the .run/ folder

For internal environments (such as Staging) a Banner will be shown on the top end part of the screen to easily identify the app against the production version. This can be configured in the [App](lib/app/app.dart) file.

#### Configuring Environments
1. Environment variables are declared in the [Environment](lib/app/config/environment.dart) class.
1. Each entry file declares its environment.
1. The [Dependencies](lib/util/dependencies.dart) class loads all the dependencies for a given environment.

#### Constants
- A [Constants](lib/app/config/constants.dart) file is available for any constants not related to the environments.
- A [WebView URLs](lib/app/config/webview_urls.dart) is also available to register all WebView URLS.

### Dependency Injection
- Dependecies can be registered using the [Dependencies](lib/util/dependencies.dart) class.
- Dependencies are loaded on each entry file for a given environment.
- A `useMocks` flag is available to register mock or test dependencies.

The project uses the service locator [get_it](https://pub.dev/packages/get_it) to register and provide dependencies through out the app.

- [ ] Review Actual Dependency Injection with https://pub.dev/packages/injectable

### Logging
- The [Flogger](lib/util/tools/flogger.dart) class is provided as a wrapper to log records to different listeners.
- Use it directly as `Flogger.level("Message")`.<br>
  *Example: Flogger.info("LaunchCompleted");*
- External log listeners are configured inside the [Dependencies](lib/util/dependencies.dart) class.
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
- [Json Serializable](https://pub.dev/packages/json_serializable): Generates toJson/fromJson methods.

> To execute the build runner use the following command: <br>
`flutter pub run build_runner build --delete-conflicting-outputs`.

> Currently on Flutter 1.22.* build_runner breaks with l10n, follow [this issue](https://github.com/dart-lang/build/issues/2835#issuecomment-703528119) instructions for the workaround.

> 💡 **TIP**: You can hide the auto-generated files in Android Studio by going to Preferences > Editor > File Types. <br> Now look for "Ignore files and folders" field at the bottom and append `*.g.dart;*.freezed.dart;*.chopper.dart`;

> 💡 **TIP**: To automatically auto-generate part classes when the code changes use the command `flutter packages pub run build_runner watch` on a console tab and leave it running there.

#### Domain Models
These classes model the app's data and are used to communicate between the UI and the Data layers.

They are platform-agnostic and contain business logic.

[Article model example](lib/data/article/model/article.dart)

#### DTO Models
- Theses clases model the data for specific services (ex: a database or API).
- They need to be converted to domain models to communicate with the UI layer.

[Article API model example](lib/data/article/service/remote/model/article_api_model.dart)

#### UI Models
- These clases hold the current state of the UI.
- They are created and manipulated only on the Bloc and exposed for the View to listen.
- On simple views this class may be omitted and the Domain models exposed directly on the Bloc.
  
[Articles State model example](lib/presentation/articles/articles_state.dart)

- A generic [DataState](lib/presentation/util/data_state.dart) class can be used to wrap domain models with idle/loading/content/error states and update the UI accordingly. 

### Network
API communication is defined using [Chopper](https://pub.dev/packages/chopper) and requests/responses serialized with [Json Serializable](https://pub.dev/packages/json_serializable).

You can see an example with [ArticleApiService](lib/data/article/service/remote/article_api_service.dart)

A [Network](lib/data/util/network.dart) class is provided wih the basic definition for an HTTP Client. It includes:
- Logging HTTP Requests as CURL.
- Adding the Authorization Token to all requests.

### Database
This project includes the [Hive](https://pub.dev/packages/hive) Database.

Each data class is stored into a **Box** which is the equivalent of a Table/Collection.

- DB Model adapters need to be register in the global [Database](lib/data/util/database.dart) class.
- Boxes are opened in the [Dependencies](lib/util/dependencies.dart) and injected to the different services.

[Articles DB Service Example](lib/data/article/service/local/article_db_service.dart)

#### Encryption
The [Database](lib/data/util/database.dart) class includes encryption using AES256.
- An Encryption Key is generated using [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) and stored in the database upon launch.
- Each box needs to be opened using the `encryptionCipher` parameter with the encryption key.

#### TODO: Streams

- [ ] Stream subscription example

### Secure Storage
Sensitive dynamic data is stored using [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage).

The [Secure Storage](lib/data/common/service/secure_storage.dart) class wrapps the plugin to store and read data securily.

### TODO: WebViews

### TODO: No Internet Connection

### TODO: Launch Screen
Logo + Background color

### Architecture

#### Bloc
- Blocs expose data to the UI and contain the presentation logic. This data can be exposed as Streams to notify changes to the UI.
- Blocs are created on the widget tree by wrapping all the child widgets that need to access the bloc. These process is done on the [Router](lib/app/navigation/router.dart) class.

Check the [ArticlesBloc](lib/presentation/articles/articles_bloc.dart) for an example.

#### TODO: Repository Pattern
##### TODO: Mocks

#### TODO: Error Handling

##### TODO: One-Time Alerts

### TODO: Tests

### TODO: App Dispose

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