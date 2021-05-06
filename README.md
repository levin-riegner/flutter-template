<!-- omit in toc -->
# Flutter Template

Flutter template Application to checkout for new projects.
Now null-safe!
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
    - [Images](#images-1)
    - [Texts](#texts)
    - [Buttons](#buttons)
    - [Errors](#errors)
    - [Widget tree order](#widget-tree-order)
    - [Testing Accessibility](#testing-accessibility)
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
  - [Secure Storage](#secure-storage)
  - [WebViews](#webviews)
  - [No Internet Connection](#no-internet-connection)
  - [Launch Screen](#launch-screen)
    - [iOS](#ios)
    - [Android](#android)
    - [Flutter](#flutter)
  - [Architecture](#architecture)
    - [Bloc](#bloc)
    - [Repository Pattern](#repository-pattern)
      - [Mocks](#mocks)
  - [Error Handling](#error-handling)
    - [One-Time Alerts](#one-time-alerts)
    - [State Errors](#state-errors)
    - [Empty States](#empty-states)
  - [Other](#other)
    - [App Dispose](#app-dispose)
    - [Logout](#logout)
    - [Register User](#register-user)
    - [Hiding the keyboard when navigating out of the screen](#hiding-the-keyboard-when-navigating-out-of-the-screen)
    - [App version](#app-version)
  - [CI/CD Integration](#cicd-integration)
    - [Fastlane](#fastlane)
      - [Android](#android-1)
      - [iOS](#ios-1)
    - [Github Actions](#github-actions)
  - [QA Console](#qa-console)
  - [App Update](#app-update)
    - [Version Bomb](#version-bomb)
    - [Optional Updates](#optional-updates)
  - [Version Tracker](#version-tracker)
  - [App Review](#app-review)
  - [TODO: Apple Privacy](#todo-apple-privacy)
  - [TODO: Tests](#todo-tests)
  - [TODO: Deeplinks (+ Navigator 2.0)](#todo-deeplinks--navigator-20)

## Installation

1. Click the `Use this template` button to create a new repository.
1. Checkout and open with Android Studio.
1. Find and rename all instances of `com.levinriegner` with the company name, including Android folders.
1. Find and rename all instances of `fluttertemplate` and `flutter_template` with the actual product name, including folders.
1. Create a new Firebase project and update the Google Services files.
1. Setup Key Signing by following the CI instructions below.
1. Clear the README file.
> ❗️ Ensure that all template variables have been changed by searching `levinriegner` and `template` on the project.
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
#### Images
- Add Semantics Label to images. A `semanticLabel` property is available on most image widgets, otherwise wrap it using the `Semantics` widget and filling the `semantics` label.
- Ensure that images coming from an API carry an `alt` text.
> ✚ Other useful semantics widgets can be found [on this article](https://medium.com/flutter-community/developing-and-testing-accessible-app-in-flutter-1dc1d33c7eea)
#### Texts
Consider that text size can always be enlarged externally and allow for text widgets to grow. 
- Provide an `overflow` implementation.
- Use the correct `textAlign` attribute.
#### Buttons
- Use "clickable" widgets only if they will take the user somwhere. Ex: Don't use an ImageButton that will only hold an Image without being clickable.
- Ensure that clickable widgets (GestureArea / InkWell) contain a child with text. Otherwise provide the `semantics` label to the clickable image.
- All tappable targets should be at least `48x48` points.
#### Errors
- Important actions should be able to be undone. In fields that show errors, suggest a correction if possible.
#### Widget tree order
- Ensure the content order generally makes logical sense, and can be read correctly from top to bottom.
  
More information around accessibility can be found in the following links:
- [L+R Document](https://docs.google.com/document/d/12fljOK6AHswEaq9F9e558XjLKIOyPxO8gyWfOKozkyk)
- [Material Design](https://material.io/design/usability/accessibility.html)
- [Flutter](https://flutter.dev/docs/development/accessibility-and-localization/accessibility)

#### Testing Accessibility
Testing can be easily done on Android using the [Accessibility Scanner App](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor&hl=en_US).
1. Open the app to enable the Scanner.
2. Start recording a session and navigate through the different screens in the app.
3. Open the Accessibility Scanner app again and review all suggestions available for each screen.
> 💡 Results for each screen can also be shared and sent to the developers for review.

Accessibility can also be tested on iOS by using the [XCode Accessibility Scanner](https://www.raywenderlich.com/6827616-ios-accessibility-getting-started)


### Theming
- Modify the [Theme file](lib/presentation/util/styles/theme.dart) to match your application's Theme.
- Modify the [Dimens file](lib/presentation/util/styles/dimens.dart) to match your application's Dimensions.
> You can see more information around theming [on the plugin repository](https://github.com/levin-riegner/flutter-design-system).

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

> Android Studio & Visual Studio Run Configurations are available inside the .run/ and .vscode/ folders respectively.

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

### Logging
- The `Flogger` class is provided by the `logging_flutter` plugin as a wrapper to log records to different listeners.
- Use it directly as `Flogger.level("Message")`.<br>
  *Example: Flogger.info("LaunchCompleted");*
- External log listeners are configured inside the [Dependencies](lib/util/dependencies.dart) class.
    > [Papertrail](https://papertrailapp.com/dashboard) is already available on this template. It will log the first 6 characters of the userId when available along with other useful platform data.

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

> 💡 **TIP**: You can hide the auto-generated files in Android Studio by going to Preferences > Editor > File Types. <br> Now look for "Ignore files and folders" field at the bottom and append `*.g.dart;*.freezed.dart;*.chopper.dart`;

> 💡 **TIP**: To automatically auto-generate part classes when the code changes use the command `flutter packages pub run build_runner watch` on a console tab and leave it running there.

#### Domain Models
These classes model the app's data and are used to communicate between the UI and the Data layers.

They are platform-agnostic and contain business logic.

[Article model example](lib/data/article/model/article.dart)

#### DTO Models
- Theses clases model the data for specific services (ex: a database or API).
- They need to be converted to domain models to communicate with the UI layer.

[Article API Model](lib/data/article/service/remote/model/article_api_model.dart) and [Article DB Model](lib/data/article/service/local/model/article_db_model.dart) examples

#### UI Models
- These clases hold the current state of the UI.
- They are created and manipulated only on the Bloc and exposed for the View to listen.
- On simple views this class may be omitted and the Domain models exposed directly on the Bloc.
  
[Articles State model example](lib/presentation/articles/articles_state.dart)

- A generic [DataState](lib/presentation/util/data_state.dart) class can be used to wrap domain models with idle/loading/content/error states and update the UI accordingly. 

### Network
API communication is defined using [Chopper](https://pub.dev/packages/chopper) and requests/responses serialized with [Json Serializable](https://pub.dev/packages/json_serializable).

You can see an example with [ArticleApiService](lib/data/article/service/remote/article_api_service.dart)

A [Network](lib/data/shared/service/remote/network.dart) class is provided wih the basic definition for an HTTP Client. It includes:
- Logging HTTP Requests as CURL.
- Adding the Authorization Token to all requests.

### Database
This project includes the [Hive](https://pub.dev/packages/hive) Database.

Each data class is stored into a **Box** which is the equivalent of a Table/Collection.

- DB Model adapters need to be register in the global [Database](lib/data/shared/service/local/database.dart) class.
- Boxes are opened in the [Dependencies](lib/util/dependencies.dart) and injected to the different services.

[Articles DB Service Example](lib/data/article/service/local/article_db_service.dart)

#### Encryption
The [Database](lib/data/shared/service/local/database.dart) class includes encryption using AES256.
- An Encryption Key is generated using [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) and stored in the database upon launch.
- Each box needs to be opened using the `encryptionCipher` parameter with the encryption key.

### Secure Storage
Sensitive dynamic data is stored using [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage).

The [Secure Storage](lib/data/common/service/secure_storage.dart) class wrapps the plugin to store and read data securily.

### WebViews
Use the `InAppWebView` widget for any in-app webviews. This widget also takes care of No Internet Connection situations.

If navigation inside the WebView is required:
- Consider adding a "Home" button on the screen to ensure the user can get back to the original site.
- Open the link with an external browser using the [url_launcher](https://pub.dev/packages/url_launcher) package.

### No Internet Connection
For views requiring Internet Connectivity wrap them with the `DSInternetRequired` widget.
- If Internet is not available, a "No Internet" view will be shown.
- When Internet is recovered, it will automatically update with the child view.

### Launch Screen
Customise the initial Splash Screen.

#### iOS
1. Inside the `Assets.xcassets` folder, replace the `LaunchLogo` image with the app launch logo.
1. Open `LaunchScreen.storyboard` and set the `View` `Background` to match the app color.

#### Android
1. Open the `launch_background.xml` and set the color to match the app color.
1. Replace the `launch_logo.png` inside the different `drawable-*hdpi` folders with the app launch logo.

#### Flutter
Optionally, you can add a [SplashScreen](lib/presentation/splash/splash_screen.dart) as the initial route to display the logo, load initial data or show an animation.

This page is entirely optional and is no longer part of the OS app launch process.

> 💡 **TIP**: You can get the different image sizes from [this generator website](https://hotpot.ai/icon-resizer).

### Architecture

#### Bloc
- Blocs expose data to the UI and contain the presentation logic. This data can be exposed as Streams to notify changes to the UI.
- Blocs are created on the widget tree by wrapping all the child widgets that need to access the bloc. These process is done on the [Router](lib/app/navigation/router.dart) class.

Check the [ArticlesBloc](lib/presentation/articles/articles_bloc.dart) for an example.

#### Repository Pattern
The presentation layer obtains and manipulates data through the different Repository classes.

Blocs contain references through all the Repositories they need.

A Repository contains one or multiple data sources from where it retrieves and stores data according to the application logic.

An example can be found on the [ArticleDataRepository](lib/data/article/repository/article_data_repository.dart), where when articles are required, they are retrieved from the API and saved on the local Database.

##### Mocks
A mock implementation of the ArticleRepository is provided by the [ArticleMockRepository](lib/data/article/repository/article_mock_repository.dart) class.

You can inject the mock implementations of the repositories to quickly prototype the UI and try every different state.

Mocks will also be used for all the UI tests in the project.

### Error Handling
1. The Repository handles the errors from the different data sources and throws the appropiate data errors for the model type.<br>
See the example with [ArticleDataError](lib/data/article/model/article_data_error.dart) throw inside [ArticleDataRepository](lib/data/article/repository/article_data_repository.dart) dependending on the results from the different data sources.
1. The Bloc catches the data errors and converts them as One-Time Errors (for example to show a popup once) or as part of the State.

#### One-Time Alerts
Alerts can be used to show non-blocking errors for a few seconds to the user.

A bloc should expose an `alerts` Stream where the view can subscribe and show the alert appropiately. The `AlertService` is provided by the Design System library to show alerts in the form of a dismissable banner.

See the example with the [ArticlesBloc](lib/presentation/articles/articles_bloc.dart), [ArticlesAlert](lib/presentation/articles/articles_alert.dart) and [ArticlesPage](lib/presentation/articles/articles_page.dart).

> ❗️ Alerts not necessary mean errors, they can also be used for example to show confirmation to user actions.

#### State Errors
An error can also be incorporated as part of the state.

For that an [ArticlesError](lib/presentation/articles/articles_error.dart) class should define all possible state errors.

This set of errors will then be used in conjunction with the [DataState](lib/presentation/util/data_state.dart) to either display a Success content response to the user or a Failure with the specific error.

See the example also with the [ArticlesBloc](lib/presentation/articles/articles_bloc.dart) and [ArticlesPage](lib/presentation/articles/articles_page.dart).

#### Empty States

An empty state **is not an error**, it should however be displayed to the user in case a Content is retrieved successfully but with an empty result. A `DSEmptyView` widget can be used for these situations.

### Other

#### App Dispose
Close all the required dependencies inside the `dispose()` function on the [Dependencies](lib/util/dependencies.dart) class.

This method will be called when the app is disposed.

#### Logout
Delete all user-related data and references inside the `clearAllLocalData()` function on the [Dependencies](lib/util/dependencies.dart) class.

> ❗️ Make sure to call this method upon your logout event.

#### Register User
Some dependencies might need to be notified when the user is registered in the app. use the `registerUser` function on the [Dependencies](lib/util/dependencies.dart) class to set the user properties to all 3rd party services.
> ❗️ Make sure to call this method upon your login event.

#### Hiding the keyboard when navigating out of the screen

- Use `FocusScope.of(context).unfocus()` to close the keyboard.

- If the user can close the screen by navigating back, wrap the parent widget with the `WillPopScope` widget and add the close keyboard code there.

Check an example in the [ArticleDetailPage](lib/presentation/articles/detail/article_detail_page.dart).

#### App version
Make sure to add the app version somewhere on the user settings/profile so we can communicate more effectively with users. You can use the `DSAppVersion` widget for that.

### CI/CD Integration
#### Fastlane
##### Android
1. Set your project variables for the `.env.environment` files inside the `android/fastlane/` folder.
1. Follow the `Code Signing` section on [this document](https://www.notion.so/CI-Continuous-Integration-006651de6c39478394ce13866ce1df21) to set up the `Keystore` securely.
##### iOS
1. Set your project variables for the `.env.environment` files inside the `ios/fastlane/` folder.
1. Follow the `Code Signing` section on [this document](https://www.notion.so/CI-Continuous-Integration-006651de6c39478394ce13866ce1df21) to set up `Match`.

#### Github Actions
1. Follow the instructions on the [CI Workflows Flutter](https://github.com/levin-riegner/ci-workflows-flutter) Repository to add Github Actions to the destination repository.
2. Follow the `GitHub Secrets` section on [this document](https://www.notion.so/CI-Continuous-Integration-006651de6c39478394ce13866ce1df21) to obtain and add the necessary Secrets for the repository.

> 🛠 App version name and number will be autogenerated from the branch name and commit count respectively.

### QA Console
For internal builds, a [QA console](lib/util/console/console_screen.dart) will be opened when shaking the device. It contains:
- **Logs Screen**: Shows a list with all the logs that happened on the app (they can be copied and pasted into an email).
- **Environment Switcher**: Restarts the app on a different environment.
- **Default logins**: A list of all common logins that will perform the login operations automatically.
  > ❗️ Make sure to update the `_performLogin` method to match your app's Login.
- **QA Configs**: A set of tools useful for QAing an app. It uses `provider` to listen to changes and a custom [QaConfig](lib/util/tools/qa_config.dart) model with the supported options. It includes:
  - Material Grid Overlay.
  - Accessibility Mode.
  > This structure can also be extended to support app-specific configurations.

### App Update
The app checks for available available updates during launch inside the `_checkAppUpdateAvailable` method on the [App](lib/app/app.dart) class.
- A Dialog is shown to the user to update the app, which only can be dismissed if the update is optional.
- If an update is available, the user is redirected to the Appstore for iOS or is prompted to update the app using Android In-App Updates.

#### Version Bomb
The app includes a dependency to `lr_app_versioning` which allows to enforce minimum app versions via custom `API` or `RemoteConfig`.

#### Optional Updates
If the app meets the minimum version criteria but an app update is available on the stores, the user will be prompted to update, with the option to dismiss the dialog.

### Version Tracker
The app includes several version tracking functionalities using the `version_tracker.dart` class.
Version tracking is enabled during the register dependencies phase by calling `appVersioning.tracker.track()`.

### App Review
This template supports in-app reviews through the [in_app_review](https://pub.dev/packages/in_app_review) plugin.
Consider requesting a review after the user has opened the app a few times and triggered a specific set(s) of action(s).
> Do not trigger the in-app review from a clickable element as it may or may not work depending on the current requests quote and obscure dark-box logic from Apple and Google.
You can see an example on how to request an in-app review inside the [ArticlesPage](lib/presentation/articles/articles_page.dart).

### TODO: Apple Privacy

### TODO: Tests

### TODO: Deeplinks (+ Navigator 2.0)