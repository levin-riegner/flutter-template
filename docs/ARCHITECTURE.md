# Architecture

This document describes the architecture of the project.

## Presentation Layer - BLoC

The presentation (UI) layer uses the [flutter_bloc library](https://pub.dev/packages/flutter_bloc) to enforce the BLoC pattern.

- Blocs contain the presentation logic and expose data to the UI.
- This data (known as state) is exposed as a single Stream for the UI to react to changes.
- The state can consist of a single model with multiple properties or a combination of multiple models like the [DataState](/lib/presentation/shared/util/data_state.dart).
- Widgets emit events to the Bloc to trigger actions that update the state.
- Blocs are created on the widget tree by wrapping all the child widgets that need to access the bloc. This is done using the `BlocProvider` widget. If a bloc is only needed in a single page, you can use the `BlocProvider` widget directly on the page and then create a separate view widget as child that contains the rest of the page.
- Blocs can be consumed by widgets using the `BlocBuilder`, `BlocListener`, and `BlocConsumer` widgets, depending on the use case.

Visit the [Bloc Library's documentation](https://bloclibrary.dev/#/) for more information.

## Data Layer - Repository Pattern

The repository pattern is used to abstract the data layer and provide a single point of access to the data.

- The Repository is responsible for deciding where to get the data from (ie: local or remote).
- Different Services are used on the repository to get the data from different sources (ie: database or api).
- Blocs use different repositories to get the data they need.

## Error Handling

1. Errors are thrown on the data layer using a specific error class (a general-purpose error class [DataError](/lib/data/shared/model/error/data_error.dart) is provided for convenience).
2. The error is caught on the bloc and passed to the state using the [DataState](/lib/presentation/shared/util/data_state.dart) model.
3. The UI is updated to show the specific error using a [Localized Message](/lib/util/extensions/data_error_extension.dart).

### One-Time Alerts

Alerts can be used to show confirmations or non-blocking errors. These can take the form of a SnackBar, a Dialog, etc.

There are 2 options for emitting and listening to alerts:

- Add a new Stream in the Bloc to emit one-time alerts and listen to them in the StatefulWidget. Make sure to listen inside `didChangeDependencies` and stop listening inside the `dispose`. The [BaseState](/lib/presentation/shared/util/base_state.dart) class can be used to simplify this process.
- Use the `BlocListener` in the widget tree to react to state changes and show the alert when necessary.

Use the [AlertService](/lib/presentation/shared/design_system/utils/alert_service.dart) to show these alerts and display a specific [Localized Message](/lib/util/extensions/data_error_extension.dart).

### Empty States

An empty state should be displayed to the user in case a Content is retrieved successfully but with an empty result. A `DSEmptyView` widget can be used for these situations.

## App Lifecycle

### Lifecycle

The [app](/lib/app/app.dart) class listens to the app lifecycle and notifies when the app is in the background or foreground.

Use it to enable/disable services that should only run when the app is in the foreground.

### Dispose

Close all the required dependencies inside the `dispose()` function on the [Dependencies](/lib/util/dependencies.dart) class.

This method will be called when the app is disposed.

## User Session Management

### Logout

Delete all user-related data and references inside the `clearAllLocalUserData()` function on the [Dependencies](/lib/util/dependencies.dart) class.

> ❗️ Make sure to call this method upon your logout event.

### Register User

Some dependencies might need to be notified when the user is registered in the app. use the `registerUser` function on the [Dependencies](/lib/util/dependencies.dart) class to set the user properties to all 3rd party services.
> ❗️ Make sure to call this method upon your login event.

## General rules

### Presentation Layer

- Avoid business logic in the widgets. Use the Blocs to handle the logic and expose the data prepared to the UI.
- All dependencies for the bloc must be injected in the constructor (dependencies are declared in the Dependencies class).
- Do not pass the Emitter between multiple methods in the bloc. Emit only in the first method, and use return values for any other additional methods.
- Models must be immutable (all variables are final).
- Do not hardcode user-facing strings, use Localized strings instead. To provide default values, either use an empty string, or hide widgets of the text is null.
- Prefer using [DataState](/lib/presentation/shared/util/data_state.dart) to handle data loading and errors on both the bloc and the widget.
- If a state becomes too complex, consider splitting it into multiple blocs/states.

### Data Layer

- Repository always receives and returns domain models (not related to db or api).
- Data services (db or api) always receive and return data/dto models.
