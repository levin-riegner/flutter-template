<!-- omit in toc -->
# Flutter Template

Flutter template Application to checkout for new projects. Now null-safe!
<!-- omit in toc -->
# Table of Contents
- [Installation](#installation)
- [Features](#features)
  - [Fonts](#fonts)
  - [Images](#images)
  - [Navigation](#navigation)
    - [The App Router](#the-app-router)
    - [The Wrappers](#the-wrappers)
    - [The Routes](#the-routes)
    - [Access AutoRouter.of and navigate](#access-autorouterof-and-navigate)
    - [Deeplinks](#deeplinks)
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
  - [Privacy](#privacy)
    - [Apple iOS 14](#apple-ios-14)
    - [GDPR, CCPA and Appstore Requirements](#gdpr-ccpa-and-appstore-requirements)
  - [Tests](#tests)
    - [Unit tests](#unit-tests)
    - [Integration tests](#integration-tests)
  - [Static Code Analysis](#static-code-analysis)
  - [Code Coverage](#code-coverage)
  - [Next Template Additions](#next-template-additions)


## Installation
1. Click the `Use this template` button to create a new repository.
1. Checkout and open with Android Studio.
   1. Find and rename all instances of `com.levinriegner` with the company name, including Android folders.
   2. Find and rename all instances of `fluttertemplate` and `flutter_template` with the actual product name, including folders. 
3. Setup Key Signing by following the CI instructions below.
2. Create a new Firebase project and update the Google Services files.
   1. Create Android app for QA and Production environments.
   2. Create iOS app for QA and Production environments.
   3. Add SHA256 signing to Android apps
      > Use `./gradlew signingReport` to view the keys information.
   4. Add ITC Team ID and Appstore App ID to iOS apps.
4. Clear the README file, keeping only the instructions below the `# FlutterTemplate` section.
5. Remove the `LICENSE.md` file or update accordingly.
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
The project uses the [auto_route package](https://github.com/Milad-Akarie/auto_route_library) for routing and deeplinking. There are three important components to take into consideration:
- [App Router](lib/app/navigation/router/app_router.dart)
- [Wrappers](lib/app/navigation/wrappers)
- [Routes](lib/app/navigation/routes.dart)

#### The App Router
Works as the navigation controller within the app. Since `auto_route` supports Nested Navigation we can separate Routers based on logic. Eg: `ArticlesRouter` and `ConsoleRouter` can be instantiated separately and work independently from each other. To create a new AutoRouter:  
1. Head to [app_router.dart](lib/app/navigation/router/app_router.dart) and add a new `AutoRoute` object to `@AdaptiveAutoRouter`'s `children` parameter.
2. Specify a [path](#the-routes), a name and a page (can be an `EmptyRouterPage` or a [Wrapper](#the-wrappers)).
3. Add child AutoRoutes inside the `children` parameter to specify the controllers for each screen, follow the same previous steps but instead of a `Wrapper` add the corresponding Widget to the `page` param.
4. (OPTIONAL) To avoid invalid or unhandled routes add a `RedirectRoute` or a prefixed Wildcard path at the end of the route list.
5. Run the code generation tool. [Click here to know how to do it](#models).

The package will automatically generate a new file with all the routes and their corresponding paths.

IMPORTANT NOTES:
- Each Router is context-scoped, this means it's not possible to navigate directly from one to another. In order to do it, we must reference the root Router first. For more information check [Access AutoRoute.of and navigate](#access-autorouteof-and-navigate)

#### The Wrappers
Wrappers are similar to middlewares, they are often used for scoping state management solutions such as Providers and BLoCs. To wrap a route:
1. Create the desired Wrapper class at [lib/app/navigation/wrappers](lib/app/navigation/wrappers) and implement your solution within the `build` method.
2. Head to [app_router.dart](lib/app/navigation/router/app_router.dart) and replace the corresponding AutoRoute's page with your previously created Wrapper.
3. Run the code generation tool. [Click here to know how to do it](#models).

IMPORTANT NOTES:
- Always return an `AutoRoute` object in the Wrapper's build method. This will allow to render sub-routes.

#### The Routes
Routes are the string paths that reference each screen. To add a new one:
1. Head to [routes.dart](lib/app/navigation/routes.dart) to map a route to a given Router.

IMPORTANT NOTES:
- Path params are defined with a slash `/` while in the AutoRouter object are defined with a colon `:`. Keep this in mind to avoid path mismatches.

#### Access AutoRouter.of and navigate
Similarly to the legacy Navigator, AutoRoute has an .of method to access the closest instance of the given context.

For navigating you should rely on `navigateNamed` method. `Navigate` methods are specially good because they automatically handle the stack depending on if the route already existed or not. For navigating back you can use `pop`.

IMPORTANT NOTES:
- When navigating between different Routers you must access the root or the navigation won't work. To access the root Router simply add `.root` to `AutoRouter.of(context)`.

For more information [check out the package documentation](https://autoroute.vercel.app)

#### Deeplinks
The project includes **Firebase Dynamic Links** to handle deeplinks in the app.
> ❗️ Make sure you have added the iOS **Team ID** and **Appstore ID** on the Firebase Project Settings before creating a URL Prefix. Otherwise the iOS link will not work until the *apple-app-site-association* file hosted by Firebase is updated (someday, somehow).

1. Enable Dynamic Links on your Firebase Project.
2. Create 2 URL prefixes for your QA and Production environments.
3. Setup **Allowlist URL pattern** for each prefix (can be found clicking the 3 vertical dots on each prefix's page).
4. Update your prefixes inside `build.gradle` for Android.
5. Update your prefixes inside the `Entitlements` files for iOS.

To use Dynamic Links with your Custom Domain follow the instructions on the [Firebase Documentation](https://firebase.google.com/docs/dynamic-links/custom-domains).

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
1. Import the auto-generated dart file using the [StringsX](lib/app/l10n/l10n.dart) extension with the following line: `import 'package:flutter_template/app/l10n/l10n.dart';`.
1. Reference localizable strings using `context.l10n.yourString`.
> Modifications to the source `arb` file will be automatically generated on every build. Optionally you can also use the following command to generate them: ```flutter gen-l10n```.

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
- [Auto Route](https://pub.dev/packages/auto_route): Generates routing classes.

> To execute the build runner use the following command: <br>
`flutter pub run build_runner build --delete-conflicting-outputs`.

> 💡 **TIP**: You can hide the auto-generated files in Android Studio by going to Preferences > Editor > File Types. <br> Now look for "Ignore files and folders" field at the bottom and append `*.g.dart;*.freezed.dart;*.chopper.dart;*.gr.dart`;

> 💡 **TIP**: To automatically auto-generate part classes when the code changes use the command `flutter packages pub run build_runner watch` on a console tab and leave it running there.

#### Domain Models
These classes model the app's data and are used to communicate between the UI and the Data layers.

They are platform-agnostic and may contain business logic. They extend `Equatable` to implement equals/hashCode and toString() automatically.

[Article model example](lib/data/article/model/article.dart)

> 💡 Consider adding the [Dart Data Class Plugin](https://plugins.jetbrains.com/plugin/12429-dart-data-class) on Android Studio to help adding model boilerplate such as constructors or copyWith.

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
This template supports in-app reviews through the [in_app_review](https://pub.dev/packages/in_app_review) plugin. You can see an example on how to request an in-app review inside the [ArticlesPage](lib/presentation/articles/articles_page.dart).
Consider requesting a review after the user has opened the app a few times and triggered a specific set(s) of action(s).
> Do not trigger the in-app review from a clickable element as it may or may not work depending on the current requests quote and unknown dark-box logic from Apple and Google.

### Privacy
#### Apple iOS 14
- When creating or updating your app on the Appstore, fill the Privacy Questionnaire with all the data the app is persisting.

- Tracking the user's IDFA or sharing personal user data with 3rd party companies now requires explicit user permission through the iOS `ATTrackingManager` and setting the minimum app version to iOS14+.
  > 1st-party services such as Crashlytics or Analytics do not require tracking consent since data is used only inside the app ecosystem and not shared with any other companies.

  This template doesn't require any tracking permission, but if you want to integrate Facebook or any Ads SDK you may consider asking for it.

#### GDPR, CCPA and Appstore Requirements
1. Non-essential data cannot be tracked or persisted without the user's explicit opt-in.
   - A method `setDataCollectionEnabled` is available on the [Dependencies](lib/util/dependencies.dart) file to toggle collection through the different services.
   - A class [UserConfig](lib/data/shared/service/local/user_config_service.dart) is available with a boolean option to store the user's opt-in. __Defaults to false__.
   > After the user explicitly opts-in or out of data collection (usually required during signup and login). Persist the choice using `UserConfig` and activate it using `Dependencies.setDataCollectionEnabled`.
2. A contact channel must be available for the user to request a complete deletion of all personal data. This also includes data stored in external services such as Google Analytics.
3. A **Delete Account** option must be provided by the app to remove the user from the platform (both deleting backend data and logging the user out of the app).

### Tests
#### Unit tests
Unit tests are located inside the `test` folder.
They can be run using the command `flutter test` and are also executed on every commit by the CI using the Test Workflow.

The project includes the [mocktail](https://pub.dev/packages/mocktail) library to create the required Mocks.

#### Integration tests
Integration and e2e tests are located inside the `integration_test` folder.
They require an actual device (or emulator) to be executed. You can run them by using the command `flutter drive --driver=test_driver/integration_test.dart --target=integration_test/your_integration_test_file.dart`;

### Static Code Analysis
This template includes `flutter_lints` to encourage good coding practices.

The rules are drawn from the [analysis_options](analysis_options.yaml) file which defaults to Dart's language recommendations.

You can also use `flutter analyze` to run analyze the whole project.

### Code coverage

[lcov](https://github.com/linux-test-project/lcov) can be used to view the test coverage on the project. It can be installed using [homebrew](https://formulae.brew.sh/formula/lcov).


1. Execute all tests in the project appending the coverage parameter: `flutter test --coverage`. This will generate a new folder `coverage/` inside the project with the `lcov.info` file report.
2. Cleanup the report from auto-generated files with `lcov --remove coverage/lcov.info 'lib/*/*.freezed.dart' 'lib/*/*.g' 'lib/*/*.chopper.dart' 'lib/*/*.gr.dart' -o coverage/lcov.info`.
3. Generate an html page from the report with `genhtml coverage/lcov.info -o coverage/html`.
4. Open the newly created page `coverage/html/index.html` to view the report.

Code coverage results are not pushed to origin as specified in [.gitignore](.gitignore).

### Next Template Additions
- Review [Mason](https://pub.dev/packages/mason)
- Review [Pigeon](https://pub.dev/packages/pigeon)

--------------

# FlutterTemplate

FlutterTemplate Flutter Application.

## Getting Started

1. Get the project dependencies with the following commands:
    ```
    flutter pub upgrade
    flutter pub get
    ```

2. Generate the missing `*.*.dart` part files from [built_value](https://pub.dev/packages/built_value#examples):
    ```
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

## Apple Signing
- Retrieve the Apple Signing Certificates *inside the ios folder*:
    ```
    fastlane match development --readonly --env qa
    ```

## Android Signing
1. Create a new folder named `private` inside the `android` directory.
2. Add a new file named `keystore.properties` inside the new "private" folder containing the following lines:
    ```
    keystoreFile=../private/keystore.jks
    keystorePassword=XXXXXXXX
    keyAlias=key_name_goes_here
    keyPassword=XXXXXXXX
    ```
3. Add the `keystore.jks` file to the folder.

## Running from command-line

- Trigger a new build for the chosen platform:
    ```
    flutter build target_platform -t lib/main_qa.dart --flavor QA --debug --verbose
    ```
    > Replace `target_platform` with `apk` (Android) or `ios` (iOS)

- To run the previous build on a device:
    ```
    flutter run -t lib/main_qa.dart --flavor QA --debug
    ```

## Troubleshooting
Try the following steps if you are having trouble running the project:

### General
- Ensure your local flutter version matches the version range specified in the `pubspec.yaml`.<br/>
    You can check your current version by running `flutter --version`.<br/>
    If you need to update your Flutter SDK use `flutter upgrade`.
- Run Flutter Clean `flutter clean`.

### iOS
- Remove DerivedData folder `rm -rf ~/Library/Developer/Xcode/DerivedData/`.
- Remove Pods folder `rm -rf ios/Pods`.
- Update Pods repository `pod repo update`.

## Release Process
To create a new release use the GitHub Actions `Internal` and `Release` Flows.

### Internal Release (QA)
1. Checkout from `master` to a new branch named `internal/a.b.c`.
2. Push to origin.
3. ☕️ Wait for the workflow to complete...
4. **iOS** (Optional): Visit the Appstore Connect portal and submit the new build to **External Testers** (if any).
- **Android**: Build is uploaded to **Firebase App Distribution**.
- **iOS**: Build is uploaded to **Testflight**.


### AppStore/PlayStore Release (Production)
1. Checkout from `master` to a new branch named `release/a.b.c`.
2. Push to origin.
3. ☕️ Wait for the workflow to complete...
4. **iOS** (Optional): Visit the Appstore Connect portal and submit the new build to **External Testers** (if any).
5. **iOS**: Create a new release on the Appstore Connect portal, select the new build and submit for Review.
6. **Android**: Navigate to the Production Track on the Google Play Console and submit the new build for Review.
> Production builds will also be avaiable to internal testers for verification through the same mechanism as the QA builds.

### General
All flows can also be dispatched manually on the GitHub website:
- Navigate to the "Actions" tab on the repository.
- Select the "Workflow" you want to trigger.
- Press the "Run workflow" button.
- Select the branch you want to run it from.
- Press "Run workflow".

An additional **Test Workflow** will also be triggered on every *push* to execute all **Unit Tests** available on the project.

### Manual Release

#### iOS
1. Switch to a new branch named `internal/a.b.c` or `release/a.b.c` depending on the release type.
2. Execute the following commands to build the Flutter app for iOS:
   1. Get the dependencies: `flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs`.
   2. Build the Flutter app:
      - **Internal Build**: `flutter build ios -t lib/main_qa.dart --flavor QA --release --no-codesign`
      - **Production Build**: `flutter build ios -t lib/main_prod.dart --flavor Production --release --no-codesign`
3. Open the ios project with XCode.
4. Ensure the right Target (**QA** or **Production**) is selected and "Any iOS Device" is set for the Build.
5. Run Product > Archive from the top menu.
6. When the iOS Archive is completed, open the Archives screen from Window > Organizer if it doesn't open automatically.
7. Select the newly created archive and tap the `Distribute App` button.
8. Keep tapping `Next` and finally `Upload`.
9. After the upload is completed, navigate to the [Appstore Website](https://appstoreconnect.apple.com/apps/) and wait for the build to be processed.
10. Once the processing is completed, submit the build to External testers or add any required Internal testers.

### IMPORTANT
Do not push new commits directly to the release and internal branches, otherwise we might end up with conflicting version codes later on.<br>
If you need to upload a new build for the same release, always **push the changes to master first** and then rebase them on top of the release/internal branch.
