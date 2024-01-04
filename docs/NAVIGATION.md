# Navigation

This document describes how navigation is architected in the app and how to add new screens.

## Library

The app uses [Go Router](https://pub.dev/packages/go_router) to handle navigation. It is a 1st-party declarative routing package for Flutter that uses the Router API to provide a convenient, url-based API for navigating between different screens. You can define URL patterns, navigate using a URL, handle deep links, and a number of other navigation-related scenarios.

You can find more information about Go Router in the [go_router package documentation](https://pub.dev/documentation/go_router/latest/index.html).

The app also uses [Go Router Builder](https://pub.dev/packages/go_router_builder), a code-generation tool, for type-safe navigation with go router.

## Router

The app router is created in the [AppRouter](/lib/app/navigation/router/app_router.dart) class. This class is responsible for creating the `GoRouter` instance used in the [MaterialApp](/lib/app/app.dart) widget, containing navigation configurations such as redirects or animations and all the application routes.

The `routes` parameter must contain all the possible routes the application can navigate to. These routes consist mainly of:

- **Name**: the name of the route, mainly for Analytics purposes.
- **Path**: the URL path that will be used to navigate to the screen.
  - The path can contain parameters that will be passed to the screen. The syntax for parameters is `:parameterName`.
  - The path value is also used for navigating via deep links.
- **Builder**: a function that returns the screen widget.
  - The function receives a `GoRouterState` instance that can be used to access **query parameters**.
  - The builder function can also be used to create a wrapper widget for the screen, such as a `Scaffold` and/or `BottomNavigationBar` which is then populated by additional child routes.

> If the same page can be accessed from different routes, it must be declared multiple times as a child inside each one of them.

## Routes

All application routes are defined in the [app_routes](/lib/app/navigation/router/routes.dart) file using the [Go Router Builder](https://pub.dev/packages/go_router_builder) notation.

- Each route is defined as a class extending `GoRouteData`, except for shell routes, which extend `ShellRouteData` and `ShellBranchData`.
- Each route class contains all the necessary constructor parameters, which can be passed as `path` parameters, `query` parameters, and/or an `extra` object.
- Each route class must implement the `build` method, which returns the screen widget, or the `buildPage` method, which can be used to animate the navigation transition.
- The top-level route class for each navigation stack must be annotated with `@TypedGoRoute` or `@TypedShellRoute` to generate the navigation tree.
- Each annotated route must contain a `path` and a `page` parameter.
  - The `path` parameter is the URL path that will be used to navigate to the screen.
  - The `page` parameter is the screen "name", used to unequivocally identify route transitions.
- The top-level annotation must start with a slash `/`. All child routes and further descendants must NOT start with a slash.

## Navigate

The most common methods for navigating between screens are `go` and `push`:

- **Go**: navigates to a new route, removing and adding routes to the stack as needed, according to the routes defined in the GoRouter. Always prefer this method when navigating to a new screen, as it will always enforce the routes hierarchy.
- **Push**: navigates to a new route, adding it to the current stack, regardless of the routes hierarchy. This is useful when navigating to a new screen outside the current navigation stack. This corresponds to a `modal` navigation.

> After navigating to a new route via `push`, using the `go` method will reset the navigation stack to the routes defined in the GoRouter.

Example:

```dart
AccountDetailsRoute(name: "Alex").go(context)
```

## Observers

The [App](/lib/app/app.dart) widget listens to the routerDelegate changes and notifies all the [RouteListener](/lib/app/navigation/listener/route_listener.dart) provided in the `routeListeners` parameter with the new route `location`, `path`, and `name`.

The `location` is the dynamic URL at this moment, with all the path and query parameters set, whereas the `path` is the constant URL for a specific route, with placeholders. For example:

- location /articles/123
- path: /articles/:id
- page: ArticleDetailPage
  
## Redirects

Go Router supports redirects, which is a concept similar to "Guards" and can be used to redirect an incoming route to another.
This can be used for example when a user is not logged in and tries to access a protected route, we can then redirect to the login page. Another use case is to protect routes from being accessed directly via deep links.

## Deeplinks

Deeplinks are supported by default as long as the path matches a route in the router. When receiving a deeplink, simply navigate to it using `context.go(deeplink)`.

For convenience, all deeplinks must be defined in the [/docs/SCREENS.md](/docs/SCREENS.md) page so that they can be easily accessed and shared.

### Top-level deeplinks

Deeplinks may point to a top-level route that may otherwise be `pushed` during regular app navigation. In this case, pressing the back button will exit the app instead of navigating back to the previous screen.

To avoid this, use the `PoppableMixin` mixin in the `Widget` as well as wrapping the page in a `WillPopScope` widget. Use the `pop` and `willPop` methods from the mixin to ensure that navigating back from the page will navigate into the app instead of exiting it.

## Tabs

GoRouter treats tab routes as any other route. To wrap tab routes in a `BottomNavigationBar` or `TabBar` add a parent `ShellRoute` to the routes, which will build the wrapper widget and then populate it with the child routes.

If additional grand-child routes should not share the tabs shell, set the `parentNavigatorKey` on the grand-child routes to match a navigator above the ShellRoute.

### Hiding the navigation shell

Sometimes we want to navigate to a child route without displaying the navigation shell (ie: hiding the bottom navigation bar). This can be achieved by specifying the same `parentNavigatorKey` on the child route class as the one used by the parent route.
Example:

```dart
static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;
```

## Adding new routes

To add a new route in the app, follow these steps:

1. Create the new Page widget in its feature folder.
2. Add a new Route class in the [app_routes](/lib/app/navigation/router/app_routes.dart) file.
3. Annotate the new route class with its corresponding annotation or add it as a child of an existing top-level route.
4. Document the new route in the [SCREENS.md](/docs/SCREENS.md) file.
5. Navigate to the route using `MyNewRoute().go(context)`.

## TODO: Animations
