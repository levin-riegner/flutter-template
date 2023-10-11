# Navigation

This document describes how navigation is architected in the app and how to add new screens.

## Library

The app uses [Go Router](https://pub.dev/packages/go_router) to handle navigation. It is a 1st-party declarative routing package for Flutter that uses the Router API to provide a convenient, url-based API for navigating between different screens. You can define URL patterns, navigate using a URL, handle deep links, and a number of other navigation-related scenarios.

You can find more information about Go Router in the [go_router package documentation](https://pub.dev/documentation/go_router/latest/index.html).

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

All application routes are defined in the [app_routes](/lib/app/navigation/router/routes.dart) file which consists of 2 parts:

1. `AppRouteData`: an enum that contains all the possible routes in the app with its constant values.
   - It is used in the `AppRouter` class to provide the `name` and `path` values for each route.
   - It can be used in a `RouteListener` to know which route is being navigated to.
   - It can be used to assign additional properties to each route, such as a `theme` or `animation`.
   - **It must match 1:1 with all the routes defined in the `AppRouter` class.**
2. `AppRoute`: a sealed class that models all navigation intents in the app with its dynamic values.
   - It is used to navigate to a specific route in a type-safe way by generating the route string with `MyAppRoute().location`.
   - It uses the constructor to enforce `path` and `query` parameters, which will then be passed to the screen.
   - The same `AppRoute` can be re-used for navigating to the same page, from different parent routes.
   - **It must match 1:1 with all the Pages in the app.**

## Tabs

GoRouter treats tab routes as any other route. To wrap tab routes in a `BottomNavigationBar` or `TabBar` add a parent `ShellRoute` to the routes, which will build the wrapper widget and then populate it with the child routes.

If additional grand-child routes should not share the tabs shell, set the `parentNavigatorKey` on the grand-child routes to match a navigator above the ShellRoute.

## Observers

The [App](/lib/app/app.dart) widget listens to the routerDelegate changes and notifies all the [RouteListener](/lib/app/navigation/listener/route_listener.dart) provided in the `routeListeners` parameter with the new route `location`, `path`, and `name`.

> The `location` is the dynamic URL at this moment, with all the path and query parameters set, whereas the `path` is the constant URL for a specific route, with placeholders.

## Redirects

Go Router supports redirects, which is a similar concept to "Route Guards" and are used to redirect a route to another route.
This is useful for example when a user is not logged in and tries to access a protected route, which will then redirect to the login page, or when a deeplink may try to access a protected route.

## Deeplinks

Deeplinks are supported by default, as long as the path and query paramaters match a route in the router. When receiving a deeplink, simply navigate to it using `context.go(deeplink)`.

A deeplink may navigate to a route at the root level, which would otherwise be pushed when navigating from the app. In this case, navigating back from the deeplink will exit the app.

## Navigation

The most common methods for navigating between screens are `go` and `push`:

- **Go**: navigates to a new route, removing and adding routes to the stack as needed, according to the routes defined in the GoRouter. This is the preferred method for navigating through the app.
- **Push**: navigates to a new route, adding it to the current stack, regardless of the routes hierarchy. This is useful when navigating to a new screen above the current child routes, and we want to be able to go back to the previous screen. This would correspond to a "modal" navigation.

> Prefer navigating using `go` to keep the navigation tree consistent. If you navitgat to a route with `push`, additional routes also need to be pushed in order to preserve the original stack.

## Adding new routes

To add a new route in the app, follow these steps:

1. Create the new Page widget in its feature folder.
2. Add a new value in the [AppRouteData](/lib/app/navigation/router/app_routes.dart) enum to define your route.
3. Create a new class extending [AppRoute](/lib/app/navigation/router/app_routes.dart) to navigate to the route.
4. Add a new GoRoute to the [AppRouter](/lib/app/navigation/router/app_router.dart) class.
5. Navigate to the route using `context.go(MyAppRoute().location)`.
6. Document the new route in the [SCREENS.md](/docs/SCREENS.md) file.

When adding a new route, pay attention to the following:

- Never use trailing slashes in the path.
- Parent routes, or Shell childs, must start with `/`.
- Child routes must NOT start with `/`.
- Routes must have unique names but can share the same relative path.
- Path parameters are prefixed by a colon, such as `:parameterName`.
