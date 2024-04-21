import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/app/navigation/router/page_transitions.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/presentation/articles/articles_page.dart';
import 'package:flutter_template/presentation/articles/blank_page.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_page.dart';
import 'package:flutter_template/presentation/auth/change_password/change_password_page.dart';
import 'package:flutter_template/presentation/auth/create_account/bloc/create_account_cubit.dart';
import 'package:flutter_template/presentation/auth/create_account/create_account_page.dart';
import 'package:flutter_template/presentation/auth/login/bloc/login_cubit.dart';
import 'package:flutter_template/presentation/auth/login/login_page.dart';
import 'package:flutter_template/presentation/auth/otp_verification/bloc/user_confirm/user_confirm_cubit.dart';
import 'package:flutter_template/presentation/auth/otp_verification/otp_verification_page.dart';
import 'package:flutter_template/presentation/bottom_navigation/bottom_navigation_page.dart';
import 'package:flutter_template/presentation/settings/account_details_page.dart';
import 'package:flutter_template/presentation/settings/settings_page.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/bloc/local_validable_cubit.dart';
import 'package:flutter_template/util/console/console_deeplinks.dart';
import 'package:flutter_template/util/console/console_environments.dart';
import 'package:flutter_template/util/console/console_logins.dart';
import 'package:flutter_template/util/console/console_page.dart';
import 'package:flutter_template/util/console/console_qa_config.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.g.dart';

//#region Console
@TypedGoRoute<ConsoleRoute>(
  path: "/console",
  name: "ConsolePage",
  routes: [
    TypedGoRoute<ConsoleEnvironmentsRoute>(
      path: "environments",
      name: "ConsoleEnvironmentsPage",
    ),
    TypedGoRoute<ConsoleLoginsRoute>(
      path: "logins",
      name: "ConsoleLoginsPage",
    ),
    TypedGoRoute<ConsoleQaConfigRoute>(
      path: "qa-configs",
      name: "ConsoleQaConfigsPage",
    ),
    TypedGoRoute<ConsoleDeeplinksRoute>(
      path: "deeplinks",
      name: "ConsoleDeeplinksPage",
    ),
  ],
)
class ConsoleRoute extends GoRouteData {
  const ConsoleRoute();

  // Use parent navigator to navigate without bottom bar
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConsolePage();
  }
}

class ConsoleEnvironmentsRoute extends GoRouteData {
  const ConsoleEnvironmentsRoute();

  // Maintain parent navigator to allow for back navigation
  // combined with forward "push" navigation
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConsoleEnvironments();
  }
}

class ConsoleLoginsRoute extends GoRouteData {
  const ConsoleLoginsRoute();

  // Maintain parent navigator to allow for back navigation
  // combined with forward "push" navigation
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConsoleLogins();
  }
}

class ConsoleQaConfigRoute extends GoRouteData {
  const ConsoleQaConfigRoute();

  // Maintain parent navigator to allow for back navigation
  // combined with forward "push" navigation
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConsoleQaConfigs();
  }
}

class ConsoleDeeplinksRoute extends GoRouteData {
  const ConsoleDeeplinksRoute();

  // Maintain parent navigator to allow for back navigation
  // combined with forward "push" navigation
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConsoleDeeplinks();
  }
}

//#endregion

//#region Bottom Navigation
// Example: https://github.com/flutter/packages/blob/main/packages/go_router_builder/example/lib/stateful_shell_route_example.dart
@TypedStatefulShellRoute<BottomNavigationPageData>(
  branches: [
    TypedStatefulShellBranch<ArticlesBranchData>(
      routes: [
        TypedGoRoute<ArticlesRoute>(
          path: "/articles",
          name: "ArticlesPage",
          routes: [
            TypedGoRoute<ArticleDetailRoute>(
              path: ":aid",
              name: "ArticleDetailPage",
            ),
          ],
        )
      ],
    ),
    TypedStatefulShellBranch<BlankBranchData>(
      routes: [
        TypedGoRoute<BlankRoute>(
          path: "/blank",
          name: "BlankPage",
          routes: [
            TypedGoRoute<ArticleBlankDetailRoute>(
              path: ":aid",
              name: "ArticleBlankDetailPage",
            ),
          ],
        )
      ],
    ),
  ],
)
class BottomNavigationPageData extends StatefulShellRouteData {
  const BottomNavigationPageData();
  @override
  Widget builder(BuildContext context, GoRouterState state,
      StatefulNavigationShell navigationShell) {
    return navigationShell;
  }

  static const String $restorationScopeId = 'bottomNavigationPage';

  static Widget $navigatorContainerBuilder(BuildContext context,
      StatefulNavigationShell navigationShell, List<Widget> children) {
    return BottomNavigationPage(
      navigationShell: navigationShell,
      children: children,
    );
  }
}

class ArticlesBranchData extends StatefulShellBranchData {
  const ArticlesBranchData();
}

class ArticlesRoute extends GoRouteData {
  const ArticlesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ArticlesPage();
  }
}

class ArticleDetailRoute extends GoRouteData {
  final String aid;
  final String? url;

  const ArticleDetailRoute({
    required this.aid,
    this.url,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ArticleDetailPage(
      id: aid,
      url: url ?? "https://www.google.com",
    );
  }
}

class BlankBranchData extends StatefulShellBranchData {
  const BlankBranchData();
}

class BlankRoute extends GoRouteData {
  const BlankRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BlankPage();
  }
}

class ArticleBlankDetailRoute extends GoRouteData {
  final String aid;
  final String? url;

  const ArticleBlankDetailRoute({
    required this.aid,
    this.url,
  });

  // Use parent navigator to navigate without bottom bar
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ArticleDetailPage(
      id: aid,
      url: url ?? "https://www.google.com",
    );
  }
}

//#endregion
//#region Settings
@TypedGoRoute<SettingsRoute>(
  path: "/settings",
  name: "SettingsPage",
  routes: [
    TypedGoRoute<AccountDetailsRoute>(
      path: "account-details",
      name: "AccountDetailsPage",
    ),
  ],
)
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return PageTransitions.sharedAxisX(
      context: context,
      state: state,
      key: const ValueKey("SettingsRouteTransition"),
      child: const SettingsPage(),
    );
  }
}

class AccountDetailsRoute extends GoRouteData {
  final String? name;
  const AccountDetailsRoute({
    this.name,
  });

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return PageTransitions.sharedAxisX(
      context: context,
      state: state,
      key: const ValueKey("AccountDetailsRouteTransition"),
      child: AccountDetailsPage(
        name: name,
      ),
    );
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AccountDetailsPage(name: name);
  }
}
//#endregion

//#region Authentication
@TypedGoRoute<LoginRoute>(
  path: "/login",
  name: "LoginPage",
)
class LoginRoute extends GoRouteData {
  const LoginRoute();

  // Use parent navigator to navigate without bottom bar
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(
            getIt<AuthRepository>(),
          ),
        ),
        BlocProvider<LocalValidableCubit>(
          create: (context) => LocalValidableCubit(),
        ),
      ],
      child: const LoginPage(),
    );
  }
}

@TypedGoRoute<CreateAccountRoute>(
  path: "/create-account",
  name: "CreateAccountPage",
)
class CreateAccountRoute extends GoRouteData {
  const CreateAccountRoute();

  // Use parent navigator to navigate without bottom bar
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CreateAccountCubit>(
          create: (context) => CreateAccountCubit(
            getIt<AuthRepository>(),
          ),
        ),
        BlocProvider<LocalValidableCubit>(
          create: (context) => LocalValidableCubit(),
        ),
      ],
      child: const CreateAccountPage(),
    );
  }
}

@TypedGoRoute<ChangePasswordRoute>(
  path: "/change-password",
  name: "ChangePasswordPage",
)
class ChangePasswordRoute extends GoRouteData {
  const ChangePasswordRoute();

  // Use parent navigator to navigate without bottom bar
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChangePasswordPage();
  }
}

@TypedGoRoute<OtpVerificationRoute>(
  path: "/otp",
  name: "OtpVerificationPage",
)
class OtpVerificationRoute extends GoRouteData {
  const OtpVerificationRoute();

  // Use parent navigator to navigate without bottom bar
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserConfirmCubit>(
          create: (context) => UserConfirmCubit(
            getIt<AuthRepository>(),
          ),
        ),
        BlocProvider<LocalValidableCubit>(
          create: (context) => LocalValidableCubit(),
        ),
      ],
      child: OtpVerificationPage(
        sendCodeOnInit: (state.extra as bool?) ?? false,
        onVerificationSuccess: (userConfirmModel) {
          context.go(
            const ArticlesRoute().location,
          );
        },
      ),
    );
  }
}
//#endregion
