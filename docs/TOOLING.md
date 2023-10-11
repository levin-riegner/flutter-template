# Tooling

This document describes how to use the Flutter tooling and 3rd party tools integrated with the project.

## Fonts

1. Add required fonts inside `assets/fonts/font_name`.
    > Ensure font file names do not contain spaces.
1. Modify the fonts section in `pubspec.yaml` to meet your requirements.

## Images

1. Drop files inside `assets/images/` folders.
    - 1x images belong inside the root folder.
    - 2x and 3x images have their own separate folder.
2. Add a new reference to the image to the [Assets](/lib/app/resources/assets.dart) class.
3. To access the image accross the app use `Assets.myImage`.

## Localization

This project uses `l10n` for localization and managing translations.

On every build, the arb files will auto-generate the corresponding .dart files to use in the project.
Alternatively, you can run `flutter gen-l10n` to generate the files manually.

> Check out the [Internationalizion User Guide](https://docs.google.com/document/d/10e0saTfAv32OZLRmONy866vnaw0I2jwL8zukykpgWBc/edit) to learn more about the l10n format.

### Translating Texts

- English is set as the default root language from which all others are translated.
- Add or update your texts inside the [English arb file](/lib/app/l10n/app_en.arb).
- Additional translation languages are available with the following convention: `lib/app/l10n/app_*.arb`.

### Adding new languages

1. Create a new file named `app_languagecode.arb` inside the `lib/app/l10n/` folder. For example: `lib/app/l10n/app_es.arb`.
    > More information about language codes can be found [here](https://wiki.mozilla.org/L10n:Locale_Codes).

2. Add the new locale inside the `Info.plist` on the iOS project as described [here](https://flutter.dev/docs/development/accessibility-and-localization/internationalization#localizing-for-ios-updating-the-ios-app-bundle).

### Using Localizable Strings

1. Import the auto-generated dart file using the [StringsX](/lib/app/l10n/l10n.dart) extension with the following line: `import 'package:global_citizen/app/l10n/l10n.dart';`.
1. Reference localizable strings using `context.l10n.yourString`.

> Modifications to the source `arb` file will be automatically generated on every build. Optionally you can also use the following command to generate them: `flutter gen-l10n`.

## Accessibility

### Images

- Add Semantics Label to images. A `semanticLabel` property is available on most image widgets, otherwise wrap it using the `Semantics` widget and filling the `semantics` label.
- Ensure that images coming from an API carry an `alt` text to populate the semantics.
- Follow good practices for alt text content from [this guideline](https://www.w3.org/WAI/tutorials/images/decision-tree/)

> ✚ Other useful semantics widgets can be found [on this article](https://medium.com/flutter-community/developing-and-testing-accessible-app-in-flutter-1dc1d33c7eea)

### Texts

Consider that text size can always be enlarged externally and allow for text widgets to grow.

- Provide an `overflow` implementation.
- Always add the appropiate `textAlign` attribute.

### Buttons

- Use "clickable" widgets only if they will take the user somwhere. Ex: Don't use an ImageButton that will only hold an Image without being clickable.
- Ensure that clickable widgets (GestureArea / InkWell) contain a child with text. Otherwise provide the `semantics` label to the clickable image.
- All tappable targets should be at least `48x48` points.
- When not using regular buttons, consider wrapping clickable widgets with [DSOpacityGestureIndicator](/lib/presentation/shared/design_system/views/ds_opacity_gesture_detector.dart) to provide visual feedback as well as a semantic label.

### Errors

- Important actions should be able to be undone. In fields that show errors, always suggest a correction or an action to take next.

### Widget tree order

- Ensure the content order generally makes logical sense, and can be read correctly from top to bottom.
  
More information around accessibility can be found in the following links:

- [L+R Accessibility Checklist](https://docs.google.com/document/d/12fljOK6AHswEaq9F9e558XjLKIOyPxO8gyWfOKozkyk)
- [Material Design](https://material.io/design/usability/accessibility.html)
- [Flutter](https://flutter.dev/docs/development/accessibility-and-localization/accessibility)

### Testing Accessibility

Testing can be easily done on Android using the [Accessibility Scanner App](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor&hl=en_US).

1. Open the app to enable the Scanner.
2. Start recording a session and navigate through the different screens in the app.
3. Open the Accessibility Scanner app again and review all suggestions available for each screen.

> 💡 Results for each screen can also be shared and sent to the developers for review.

Accessibility can also be tested on iOS by using the [XCode Accessibility Scanner](https://www.raywenderlich.com/6827616-ios-accessibility-getting-started)

## Theming

- Modify the [Theme file](/lib/presentation/shared/design_system/utils/theme.dart) to match the application's Theme.
- Modify the [Dimens file](/lib/presentation/shared/design_system/utils/dimens.dart) to match the application's Dimensions.

### Theme Modes

The app has two themes: Dark and Light. These are applied throughout the app in an interactive way via [AdaptiveThemeCubit](/lib/presentation/shared/adaptive_theme/adaptive_theme_cubit.dart).

The app will switch to the corresponding theme depending on the currently displayed screen via [ThemeRouteListener](/lib/app/navigation/listener/theme_route_listener.dart).

### Theme Extensions

Theme extensions come handy when complying with specific properties such as a concrete design for one Widget or a more elabare text style guide. In order to add and use a new Theme Extension:

- Create a class extending `ThemeExtension` inside the [Theme File](/lib/presentation/shared/design_system/utils/theme.dart) with the desired properties.
- Add the newly created extension into the `extensions` property for both Dark and Light `ThemeData` instances.
- To use the extension and its properties, obtain it with the `Theme.of(context).extensions<T>()` convenience method.

See the [Documentation](https://api.flutter.dev/flutter/material/ThemeData/extensions.html) for additional info and an interactive example.

## Analytics

An [Analytics](/lib/util/integrations/analytics.dart) class wrapper is provided to expose common Analytics functionality.
  
Currently the project uses Google Analytics.

Check the [ANALYTICS.md](/docs/ANALYTICS.md) documentation to learn more about Analytics.

### Screen Views

Screen views are tracked automatically using the [AnalyticsRouteListener](/lib/app/navigation/listener/analytics_route_listener.dart) with the screen name set to the current URL path (ie: screenName="/home/items/123").

### Events

1. Add new Events inside the [AnalyticsEvent](/lib/util/tools/analytics_event.dart) class.
2. Track events using `Analytics.instance.track(AnalyticsEvent)`.

### User Identity

After login, call `Analytics.identify(user)` to set the user information. Ensure this method is called at least once per session to keep the user traits updated.

After logout, call `Analytics.logout()` to clear the user traits.

By default the app will not record data to the Analytics services to comply with GDPR regulations. After the user accepts the Terms of Service, call `Dependencies.setDataCollectionEnabled(true)` to begin recording data.

### UTM Parameters

When the app is opened from a Deeplink, App/Universal Link or push notification, those may contain UTM parameters to know where the user came from. Make sure to manually call `Analytics.instance.trackUtmParameters(source, medium, campaign)` to track those parameters.

## App Environments

This project supports 2 environments:

1. **QA**: For development and testing (also called "Staging").
2. **Production**: For appstore releases.

The environment setup can be found on:

- **Android**: project level [build.gradle](/android/app/build.gradle).
- **iOS**: Schemes & Configurations.
- **Flutter**: `main_**.dart` entry files.

> More info about environment setup can be found [in this document](https://www.notion.so/App-Environments-01422cd3d1d74aec8fb8e4b3f4fd14fb).

The Visual Studio Run Configurations are available in the [launch.json](/.vscode/launch.json) file.

### Configuring Environments

1. Environment variables are declared in the [Environment](/lib/app/config/environment.dart) class.
1. Each entry file declares its environment.
1. The [Dependencies](/lib/util/dependencies.dart) class loads all the dependencies for a given environment.

### Constants

- A [Constants](/lib/app/config/constants.dart) file is available for any constants not related to the environments.
- A [WebView URLs](/lib/app/config/webview_urls.dart) is also available to register all WebView URLS.

## Dependency Injection

- Dependecies can be registered using the [Dependencies](/lib/util/dependencies.dart) class.
- Dependencies are loaded on each entry file for a given environment.

The project uses the service locator [get_it](https://pub.dev/packages/get_it) to register and provide dependencies through out the app.

## Logging

- The `Flogger` class is provided by the [logging_flutter](https://pub.dev/packages/logging_flutter) plugin as a wrapper to log records to different listeners.
- Use it directly as `Flogger.level("Message")`. For example: `Flogger.info("LaunchCompleted")`;
- External log listeners are configured inside the `_initLogging()` method on the [Dependencies](/lib/util/dependencies.dart) class.
- [Datadog](https://app.datadoghq.com/logs) is used as the remote logging service on [datadog.dart](/lib/util/integrations/datadog.dart).

## Crashlytics

This project uses Firebase Crashlytics to monitor and report crashes.

iOS builds automatically upload dSYMS to Firebase as part of the Build Phases.

Logs recorded before the crash are sent as part of the crash report.

## Models

This project uses [build_runner](https://pub.dev/packages/build_runner) to auto-generate the necessary boilerplate for model classes. The plugins triggered by the build are:

- [Freezed](https://pub.dev/packages/freezed): Generates toString, equals and hashCode. Creates immutable classes.
- [Json Serializable](https://pub.dev/packages/json_serializable): Generates toJson/fromJson methods.
- [Isar](https://pub.dev/packages/isar): Generates database models.

Execute the build runner with the following command: `flutter pub run build_runner build --delete-conflicting-outputs`.

> 💡 **Pro tip**: To automatically auto-generate part classes while working, use the command `flutter packages pub run build_runner watch` on a console tab and leave it running there.

### Domain Models

These classes model the app's data and are used to communicate between the UI and the Data layers.

- They are platform-agnostic and may contain business logic.
- They are named using the `*Model` suffix and extend `Equatable` to implement equals/hashCode and toString() automatically.

### DTO Models

- Theses clases model the data for specific services (ie: a database or API).
- They need to be converted to domain models to communicate with the UI layer (ie: from db model to model).

### UI Models

- These clases hold the current state of the UI.
- They are created and manipulated only on the Bloc and exposed for the View to listen.
- On simple views this class may be omitted and the Domain models exposed directly on the Bloc.
- A generic [DataState](/lib/presentation/util/data_state.dart) class can be used to wrap domain models with idle/loading/content/error states.

## Network

A [Network](/lib/data/shared/service/remote/network.dart) class is provided wih the basic definition for HTTP and GraphQL clients. It includes:

- Adding the Authorization Token to all requests.
- Adding an API Key and User Agent to all requests.
- Logging HTTP requests.
- Printing requests as CURL.

These are done by making use of Interceptors for the HTTP client and Links for the GraphQL client.

### REST

API communication is defined using [Dio](https://pub.dev/packages/dio) and requests/responses are serialized with [Json Serializable](https://pub.dev/packages/json_serializable).

#### Interceptors

Interceptors are useful for treating requests and/or responses before they are handled by the client, such as adding headers, logging, caching, etc.

You can create your own custom Interceptor by extending the [Interceptor](https://pub.dev/packages/dio#interceptors) class.

To add it to the Dio client, instantiate it into the `interceptors` list.

#### Cache

The app will cache all API requests by default, following the `Cache-Control` headers defined in the API responses.

The [dio_cache_interceptor](https://pub.dev/packages/dio_cache_interceptor) is used to apply this setting to all requests when creating an http client via the [Network](/lib/data/shared/service/remote/network.dart) class.

## Database

This project uses the [Isar](https://pub.dev/packages/isar) Database.

Each db model is annotated as a @collection which creates all the required auto-generated code.

- DB Model collections need to be registered in the global [Database](/lib/data/shared/service/local/database.dart) class.
- Collections are retrieved in the [Dependencies](/lib/util/dependencies.dart) and injected to the different services.

## Secure Storage

Sensitive dynamic data is stored using [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage).

The [Secure Storage](/lib/data/shared/service/local/secure_storage.dart) class wrapps the plugin to store and read data securily.

## WebViews

Use the [InAppWebView](/lib/presentation/shared/design_system/utils/inapp_webview.dart) widget for any in-app webviews. This widget also takes care of No Internet Connection situations.

If navigation inside the WebView is required:

- Consider adding a "Home" button on the screen to ensure the user can get back to the original site.
- Open the link with an external browser using the [url_launcher](https://pub.dev/packages/url_launcher) package.

## No Internet Connection

For views requiring Internet Connectivity wrap them with the [DSInternetRequired](/lib/presentation/shared/design_system/views/ds_internet_required.dart) widget.

- If Internet is not available, a "No Internet" view will be shown.
- When Internet is recovered, it will automatically update with the child view.
- A callback can be provided to be executed when Internet is recovered (ie: execute API call).

## Launch Screen

Customise the initial Splash Screen.

### iOS

1. Inside the `Assets.xcassets` folder, replace the `LaunchLogo` image with the app launch logo.
1. Open `LaunchScreen.storyboard` and set the `View` `Background` to match the app color.

### Android

This project uses the new [Android 12+ Splash Screen](https://developer.android.com/guide/topics/ui/splash-screen).

1. Create a new Vector Drawable (**xml**) with the app launch logo.
2. Open the `styles.xml` file.
3. Set the `windowSplashScreenBackground` color to match the app color.
4. Set the `windowSplashScreenAnimatedIcon` drawable to the previously created xml logo.

### Flutter

Optionally, you can add a SplashScreen as the initial route to display the logo, load initial data or show an animation.

This page is entirely optional and is no longer part of the OS app launch process.

> 💡 **TIP**: You can get the different image sizes from [this generator website](https://hotpot.ai/icon-resizer).

## Other

### Hiding the keyboard when navigating out of the screen

- Use `FocusScope.of(context).unfocus()` to close the keyboard.

- If the user can close the screen by navigating back, wrap the parent widget with the `WillPopScope` widget and add the close keyboard code there.

### Animations

This project uses [flutter_animate](https://pub.dev/flutter_animate) package to add animations to Widgets. To use it, simply import the package and add `animate()` method at the end of the Widget that will be animated. Add the animation effect inside the `effects` parameter.

### App version

Make sure to add the app version somewhere on the user settings/profile so we can communicate more effectively with users. You can use the [DSAppVersion](/lib/presentation/shared/design_system/views/ds_app_version.dart) widget for that.

## CI/CD Integration

### Fastlane

#### Android

1. Set your project variables for the `.env.environment` files inside the `android/fastlane/` folder.
1. Follow the `Code Signing` section on [this document](https://www.notion.so/CI-Continuous-Integration-006651de6c39478394ce13866ce1df21) to set up the `Keystore` securely.

#### iOS

1. Set your project variables for the `.env.environment` files inside the `ios/fastlane/` folder.
1. Follow the `Code Signing` section on [this document](https://www.notion.so/CI-Continuous-Integration-006651de6c39478394ce13866ce1df21) to set up `Match`.

### Github Actions

1. Follow the instructions on the [CI Workflows Flutter](https://github.com/levin-riegner/ci-workflows-flutter) Repository to add Github Actions to the destination repository.
2. Follow the `GitHub Secrets` section on [this document](https://www.notion.so/CI-Continuous-Integration-006651de6c39478394ce13866ce1df21) to obtain and add the necessary Secrets for the repository.

> 🛠 App version name and number will be autogenerated from the branch name and commit count respectively.

## QA Console

For internal builds, a [QA console](/lib/util/console/console_screen.dart) will be opened when shaking the device. It contains:

- **Logs Screen**: Shows a list with all the logs that happened on the app (they can be copied and pasted into an email).
- **Environment Switcher**: Restarts the app on a different environment.
- **Default logins**: A list of all common logins that will perform the login operations automatically.
  > ❗️ Make sure to update the `_performLogin` method to match your app's Login.
- **QA Configs**: A set of tools useful for QAing an app. It uses `provider` to listen to changes and a custom [QaConfig](/lib/util/tools/qa_config.dart) model with the supported options. It includes:
  - Material Grid Overlay.
  - Accessibility Mode.
  > This structure can also be extended to support app-specific configurations.
- **Deeplinks**: An input text to test deeplink navigation within the app. Enter the deeplink (web or app) and press `Navigate` to navigate to the screen.

Use the following command on Android to simulate a shake and open the QA console:

  ```bash
  adb emu sensor set acceleration 100:100:100; sleep 1; adb emu sensor set acceleration 0:0:0
  ```

## App Update

The app checks for available available updates during launch inside the `_checkAppUpdateAvailable` method on the [App](/lib/app/app.dart) class.

- A Dialog is shown to the user to update the app, which only can be dismissed if the update is optional.
- If an update is available, the user is redirected to the Appstore for iOS or is prompted to update the app using Android In-App Updates.

### Version Bomb

The app includes a dependency to `app_versioning` which allows to enforce minimum app versions via custom `API` or `RemoteConfig`.

### Optional Updates

If the app meets the minimum version criteria but an app update is available on the stores, the user will be prompted to update, with the option to dismiss the dialog.

## Version Tracker

The app includes several version tracking functionalities using the `version_tracker.dart` class.
Version tracking is enabled during the register dependencies phase by calling `appVersioning.tracker.track()`.

## App Review

You can use the [in_app_review](https://pub.dev/packages/in_app_review) plugin to prompt the user to leave a review.

Consider requesting a review after the user has opened the app a few times or triggered a specific set of actions.
> Do not trigger the in-app review from a clickable element as it may or may not work depending on the current requests quote and unknown dark-box logic from Apple and Google.

## Permissions

To request iOS/Android sytem permissions at runtime, use the [PermissionsService](/lib/util/tools/permissions_service.dart) class which wraps the [permission_handler](https://pub.dev/packages/permission_handler) plugin.

For iOS also perform the following steps.

1. Enable the permission on the [Podfile](/ios/Podfile) by changing its value from `0` to `1`.
2. Add the appropiate permission usage description to the [Info.plist](ios/Runner/Info.plist).
3. Enable the permission on the project Capabilities if necessary.

## Push Notifications

This project uses [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) to receive push notifications.

Use the [PushNotificationsHelper](/lib/util/integrations/notifications/push_notifications_helper.dart) class to register the device token and handle incoming notifications.
Request the push notification permission at an appropiate time using the `requestPermissionIfNotRequested()` method.

Subscriptions for the push token and push messages are performed on the [App](/lib/app/app.dart) class.
When the token changes, you can send it to the backend to register the device.

Push notifications can contain deeplinks to navigate the user to a specific screen inside the app. Depending on the app state, push notifications should be presented differently to the user:

- If the app is in the foreground, show an alert with an action button.
- If the app is in the background, navigate to the destination.

## Performance Monitoring

The project includes [Firebase Performance Monitoring](https://firebase.google.com/docs/perf-mon) to automatically collect and monitor the following performance metrics:

- App start time, and foreground/background times.
- HTTPS Network requests (via [dio_firebase_performance](https://pub.dev/packages/dio_firebase_performance)).

You can also add custom monitoring code to measure performance for other metrics. To learn more about custom code traces visit the [Firebase Performance Monitoring](https://firebase.google.com/docs/perf-mon/custom-code-traces?platform=flutter) documentation.

## Remote Config

The project includes [Firebase Remote Config](https://firebase.google.com/docs/remote-config) for feature flags and small configuration changes.

Use the [remote_config.dart](/lib/util/integrations/remote_config.dart) class to access the remote config values or add new ones.

Make sure all remote config values are updated and added on both the Staging and Production Firebase projects.

## Privacy

### Apple iOS 14

- When creating or updating your app on the Appstore, fill the Privacy Questionnaire with all the data the app is persisting.

- Tracking the user's IDFA or sharing personal user data with 3rd party companies now requires explicit user permission through the iOS `ATTrackingManager` and setting the minimum app version to iOS14+.
  > 1st-party services such as Crashlytics or Analytics do not require tracking consent since data is used only inside the app ecosystem and not shared with any other companies.

  This project doesn't require any tracking permission, but if you want to integrate Facebook or any Ads SDK you may consider asking for it.

### GDPR, CCPA and Appstore Requirements

1. Non-essential data cannot be tracked or persisted without the user's explicit opt-in.
   - A method `setDataCollectionEnabled` is available on the [Dependencies](/lib/util/dependencies.dart) file to toggle collection through the different services.
   - A class [UserConfig](/lib/data/shared/service/local/user_config_service.dart) is available with a boolean option to store the user's opt-in.
   > After the user explicitly opts-in or out of data collection (usually required during signup and login). Persist the choice using `UserConfig` and activate it using `Dependencies.setDataCollectionEnabled`.
2. A contact channel must be available for the user to request a complete deletion of all personal data. This also includes data stored in external services such as Google Analytics.
3. A **Delete Account** option must be provided by the app to remove the user from the platform (both deleting backend data and logging the user out of the app).

## Changing the flutter sdk

This project uses [fvm](https://fvm.app/) to manage the flutter sdk version and share it across the team and CI processes.

To set a different flutter version for the project, run `fvm use x.y.z`.

## Recording videos

You can record a video of the app using an Android emulator.
Run the app on the emulator and run the following commands:

- Start recording:

  ```bash
  adb shell screenrecord /sdcard/video.mp4
  ```

- Stop recording by pressing `Cmd+c` on the terminal.
- To download the video to your computer run:

  ```bash
  adb pull /sdcard/video.mp4
  ```

## Platform Channels

Flutter uses [Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels) to communicate back and forth with native code.

This project leverages the [pigeon](https://pub.dev/packages/pigeon) package to generate the boilerplate for the platform channel code.

### Usage

- The [/pigeons](/pigeons) folder contains one "pigeon" file for each platform channel.
- The pigeon file contains all the messages (methods) that can be sent between the Dart and native code.
  - Contains a header to specify which files to generate (note that files need to be created before-hand).
  - Contains the list of messages (methods) that can be sent between the Dart and native code.
  - Dart to native messages are defined using the `@HostApi()` annotation. Native to Dart messages are defined using the `@FlutterApi()` annotation.

- Navigate to the Android and iOS generated files and add the necessary code to make them work.
- Add the new channel to the [AppDelegate](/ios/Runner/AppDelegate.swift) and [MainActivity](/android/app/src/main/kotlin/org/globalcitizen/app/MainActivity.kt) files.
- Use the generated dart file in [/lib/util/channels](/lib/util/channels) to access the generated methods to send messages to the native code.

Visit the [pigeon example](https://github.com/flutter/packages/tree/main/packages/pigeon/example) project for more information.
