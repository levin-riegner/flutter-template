# Testing

Before submitting a PR, make sure you have added enough tests to cover your changes and the different edge cases.

## Adding tests

As a general rule, if you are adding a new feature, you should add tests for it. If you are fixing a bug, you should add a test that fails without your fix and passes with it.

The most importants tests are the unit tests, located in the [tests](/test/) folder. A minimal test coverage for a new feature would include:

- A test for the bloc, aiming at 100% code coverage.
- A test for any new logic in the model or utils folders.

## Test Types

### Unit tests

Unit tests are located inside the [test/](/test/) folder.
They can be run using the command `flutter test` and are also executed on every commit by the CI using the **Test Workflow**.

The project includes the [mocktail](https://pub.dev/packages/mocktail) library to create the required Mocks and [bloc_test](https://pub.dev/packages/bloc_test) to test BLoCs.

### Integration tests

Integration and e2e tests are located inside the [integration_test/](/integration_test/) folder.
They require an actual device (or emulator) to be executed. You can run them by using the command `flutter test integration_test --flavor qa -d deviceId`;

## Static Code Analysis

This project uses [flutter_lints](https://pub.dev/packages/flutter_lints) to encourage good coding practices.

The rules are drawn from the [analysis_options](analysis_options.yaml) file which defaults to Dart's language recommendations.

You can also use `flutter analyze` to run analyze the whole project.

## Code coverage

[lcov](https://github.com/linux-test-project/lcov) can be used to view the test coverage on the project. It can be installed using [homebrew](https://formulae.brew.sh/formula/lcov).

1. Execute all tests in the project appending the coverage parameter: `flutter test --coverage`. This will generate a new folder `coverage/` inside the project with the `lcov.info` file report.
2. Cleanup the report from auto-generated files with `lcov --remove coverage/lcov.info 'lib/*/*.freezed.dart' 'lib/*/*.g' 'lib/*/*.gr.dart' -o coverage/lcov.info`.
3. Generate an html page from the report with `genhtml coverage/lcov.info -o coverage/html`.
4. Open the newly created page `coverage/html/index.html` to view the report.

```bash
flutter test --coverage && lcov --remove coverage/lcov.info 'lib/*/*.freezed.dart' 'lib/*/*.g' 'lib/*/*.gr.dart' -o coverage/lcov.info && genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html
```

## General rules

- All business logic should be tested. That mainly encompasses blocs, but also any logic in the models, repositories or util files.
