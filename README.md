# Flutter Template

Flutter template Application to checkout for new projects.
Check the [docs/](/docs/) folder for all the features and documentation.

## Installation

1. Click the `Use this template` button to create a new repository.
1. Remove the `LICENSE.md` file or update accordingly.
1. Checkout and open with Android Studio.
   1. Find and rename all instances of `com.levinriegner` with the company name, including Android folders.
   2. Find and rename all instances of `fluttertemplate` and `flutter_template` with the actual product name, including folders.
1. Setup Key Signing by following the CI instructions below.
1. Create a new Firebase project and update the Google Services files.
   1. Create Android app for QA and Production environments.
   2. Create iOS app for QA and Production environments.
   3. Add SHA256 signing to Android apps
      > Use `./gradlew signingReport` to view the keys information.
   4. Add ITC Team ID and Appstore App ID to iOS apps.
1. Update or remove the Branch.io setup.
1. Update or remove the DataDog setup.
1. Clear the README file, keeping only the instructions below the `# FlutterTemplate` section.

> ❗️ Ensure that all template variables have been changed by searching `levinriegner` and `template` on the project.

--------------

# FlutterTemplate

FlutterTemplate Flutter Application. Add a description of what the app does.

> Before you start, read this README and the [docs/](/docs/) to learn about the project and how to contribute.

## Getting Started

1. Get the project's flutter version using [fvm](https://fvm.app/).

   ```bash
   fvm install
   ```

   > ❗️ Make sure to add fvm as an alias for `fvm flutter` in your shell configuration file (ie: `~/.bash_profile` or `~/.zprofile`). This will allow you to use `flutter` directly instead of `fvm flutter`. See the [fvm docs](https://fvm.app/docs/guides/running_flutter/#proxy-commands) for more information.

1. Get the project dependencies with the following commands:

    ```bash
    flutter pub get
    ```

1. Generate the missing `*.*.dart` part files with the [build_runner](https://pub.dev/packages/build_runner):

    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

    > During development, you can also run `flutter pub run build_runner watch` on a console tab to automatically re-run the build_runner when part files change.

## Development Process

Review the [CONTRIBUTING.md](/CONTRIBUTING.md) file to learn about the development process.

### Apple Signing

Retrieve the Apple Signing Certificates *inside the ios folder* using the appstore connect API Key available in 1Password:

```bash
fastlane match development --readonly --api_key_path api_key.json --env qa
```

### Android Signing

1. Create a new folder named `private` inside the `android` directory.
2. Add a new file named `keystore.properties` inside the new "private" folder containing the following lines (fill from 1Password):

    ```bash
    keystoreFile=../private/keystore.jks
    keystorePassword=XXXXXXXX
    keyAlias=YYYYYYY
    keyPassword=ZZZZZZ
    ```

3. Add the `keystore.jks` file to the folder.

### Integrated Development Environment (IDE)

This project is configured to work with [Visual Studio Code](https://code.visualstudio.com/).

You can find useful extensions for this project inside the [.vscode/extensions.json](.vscode/extensions.json) file.

Useful shortcuts for Visual Studio Code:

- **⌘P**: Open File.
- **⌘↑P**: Open Command Palette.
- **fnF5**: Run and debug.
- **⌘.**: Show code suggestions.

Saving a file on Visual Studio code will:

- Trigger a hot reload.
- Format the code using [dart format](https://dart.dev/tools/dart-format).
- Autofix issues and warnings using [flutter_lints](https://pub.dev/packages/flutter_lints).
- Sort imports and remove unused imports.

## Deployment

To create a new release use the GitHub Actions `Internal` and `Release` Flows.

### Internal Release (QA)

New internal builds are sent every 2 weeks on Monday, following the end of the sprint.

1. Checkout from `master` to a new branch named `internal/a.b.c`.
2. Push to origin.

- **Android**: Build is uploaded to **Firebase App Distribution**.
- **iOS**: Build is uploaded to **Testflight**.

### AppStore/PlayStore Release (Production)

New production builds are sent for store review once the matching internal build has been approved by the QA team.

1. Checkout from `internal/a.b.c` to a new branch named `release/a.b.c`.
2. Push to origin.
3. Wait for the workflow to complete...
4. **iOS**: Create a new release on the Appstore Connect portal, select the new build and submit for Review.
5. **Android**: Navigate to the Production Track on the Google Play Console and submit the new build for Review.

Production builds will also be avaiable to testers for verification through the same distribution methods as the internal builds.

### Changelog

A new GitHub Release will be created for each **release branch**, with its correponding version tag.

The [CHANGELOG.md](/CHANGELOG.md) file will also be updated with details from the Pull Requests on that version.

> 💡 You can use the [GitHub CLI](https://cli.github.com/) locally to list all the Pull Requests that were merged after a specific date. Find the datetime of last PR available in the last *release branch* and use `gh pr list --search "merged:>=2023-04-19T17:37:00+02:00 base:master sort:updated-desc"` to see all the PRs that followed on *master*.

### Additional builds for the same release

#### Internal

If you need to upload a new build for the same internal release, first push the changes to **master** and then rebase/merge them on top of the internal branch.

#### Production

Additional builds cannot be sent for the same production release.
Simply create a new release branch with an increased version name.

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

## Troubleshooting

Try the following steps if you are having trouble running the project:

### General

- Run Flutter Clean `flutter clean` to remove the project cache. Follow up with pub get and build_runner before building the app again.
- Run `fvm install` to ensure you are using the correct version of the flutter sdk.
- Run `flutter --version` and ensure the output version matches the `flutterSdkVersion` in the [fvm_config.json](/.fvm/fvm_config.json) file.
- Run Flutter Doctor `flutter doctor` to check if there are any issues with the flutter installation.

### iOS

- Remove DerivedData folder `rm -rf ~/Library/Developer/Xcode/DerivedData/`.
- Remove Pods folder `rm -rf ios/Pods`.
- Update Pods repository `pod repo update`.

## Flutter resources

- [Flutter Documentation](https://flutter.dev/docs).
- [Flutter Learn](https://flutter.dev/learn).
- [Flutter Youtube Channel](https://www.youtube.com/c/flutterdev).
- [Bloc Library](https://bloclibrary.dev/#/).
- [Dart Language](https://dart.dev/guides/language).
- [Dart Style Conventions](https://dart.dev/guides/language/effective-dart/style) and [Flutter Style Conventions](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo).

## Related repositories

- [Flutter Template](https://github.com/levin-riegner/flutter-template): The template used to create this project.
