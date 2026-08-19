import 'package:flutter/widgets.dart';
import 'package:swiss_ai/app/navigation/navigator_holder.dart';
import 'package:swiss_ai/app/navigation/router/page_transitions.dart';
import 'package:swiss_ai/presentation/articles/articles_page.dart';
import 'package:swiss_ai/presentation/articles/blank_page.dart';
import 'package:swiss_ai/presentation/articles/detail/article_detail_page.dart';
import 'package:swiss_ai/presentation/authentication/login/login_page.dart';
import 'package:swiss_ai/presentation/bottom_navigation/bottom_navigation_page.dart';
import 'package:swiss_ai/presentation/chat/chat_page.dart';
import 'package:swiss_ai/presentation/corrector/corrector_page.dart';
import 'package:swiss_ai/presentation/capture/capture_page.dart';
import 'package:swiss_ai/presentation/deck_manager/deck_manager_page.dart';
import 'package:swiss_ai/presentation/focus/focus_page.dart';
import 'package:swiss_ai/presentation/hf_model/hf_model_page.dart';
import 'package:swiss_ai/presentation/image_gen/image_gen_page.dart';
import 'package:swiss_ai/presentation/personas/personas_page.dart';
import 'package:swiss_ai/presentation/recording/recording_page.dart';
import 'package:swiss_ai/presentation/settings/account_details_page.dart';
import 'package:swiss_ai/presentation/settings/settings_page.dart';
import 'package:swiss_ai/presentation/quiz/quiz_page.dart';
import 'package:swiss_ai/presentation/research/research_page.dart';
import 'package:swiss_ai/presentation/study/study_page.dart';
import 'package:swiss_ai/presentation/study_tutor/study_tutor_page.dart';
import 'package:swiss_ai/util/console/console_deeplinks.dart';
import 'package:swiss_ai/util/console/console_environments.dart';
import 'package:swiss_ai/util/console/console_logins.dart';
import 'package:swiss_ai/util/console/console_page.dart';
import 'package:swiss_ai/util/console/console_qa_config.dart';
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
class ConsoleRoute extends GoRouteData with $ConsoleRoute {
  const ConsoleRoute();

  // Use parent navigator to navigate without bottom bar
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ConsolePage();
  }
}

class ConsoleEnvironmentsRoute extends GoRouteData with $ConsoleEnvironmentsRoute {
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

class ConsoleLoginsRoute extends GoRouteData with $ConsoleLoginsRoute {
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

class ConsoleQaConfigRoute extends GoRouteData with $ConsoleQaConfigRoute {
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

class ConsoleDeeplinksRoute extends GoRouteData with $ConsoleDeeplinksRoute {
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
    TypedStatefulShellBranch<ChatBranchData>(
      routes: [
        TypedGoRoute<ChatRoute>(
          path: "/chat",
          name: "ChatPage",
          routes: [
            TypedGoRoute<ResearchRoute>(
              path: "research",
              name: "ResearchPage",
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ImageGenBranchData>(
      routes: [
        TypedGoRoute<ImageGenRoute>(
          path: "/image-gen",
          name: "ImageGenPage",
        ),
      ],
    ),
    TypedStatefulShellBranch<RecordingBranchData>(
      routes: [
        TypedGoRoute<RecordingRoute>(
          path: "/recording",
          name: "RecordingPage",
        ),
      ],
    ),
    TypedStatefulShellBranch<HfModelBranchData>(
      routes: [
        TypedGoRoute<HfModelRoute>(
          path: "/models",
          name: "HfModelPage",
        ),
      ],
    ),
    TypedStatefulShellBranch<CorrectorBranchData>(
      routes: [
        TypedGoRoute<CorrectorRoute>(
          path: "/corrector",
          name: "CorrectorPage",
        ),
      ],
    ),
    TypedStatefulShellBranch<PersonasBranchData>(
      routes: [
        TypedGoRoute<PersonasRoute>(
          path: "/personas",
          name: "PersonalitiesPage",
        ),
      ],
    ),
    TypedStatefulShellBranch<StudyBranchData>(
      routes: [
        TypedGoRoute<StudyRoute>(
          path: "/study",
          name: "StudyPage",
          routes: [
            TypedGoRoute<StudyTutorRoute>(
              path: "tutor",
              name: "StudyTutorPage",
            ),
            TypedGoRoute<DeckManagerRoute>(
              path: "deck-manager",
              name: "DeckManagerPage",
            ),
            TypedGoRoute<QuizRoute>(
              path: "quiz",
              name: "QuizPage",
            ),
            TypedGoRoute<CaptureRoute>(
              path: "capture",
              name: "CapturePage",
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<FocusBranchData>(
      routes: [
        TypedGoRoute<FocusRoute>(
          path: "/focus",
          name: "FocusPage",
        ),
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

class ArticlesRoute extends GoRouteData with $ArticlesRoute {
  const ArticlesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ArticlesPage();
  }
}

class ArticleDetailRoute extends GoRouteData with $ArticleDetailRoute {
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

class BlankRoute extends GoRouteData with $BlankRoute {
  const BlankRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BlankPage();
  }
}

class ArticleBlankDetailRoute extends GoRouteData with $ArticleBlankDetailRoute {
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

class ChatBranchData extends StatefulShellBranchData {
  const ChatBranchData();
}

class ChatRoute extends GoRouteData with $ChatRoute {
  const ChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatPage();
  }
}

class ImageGenBranchData extends StatefulShellBranchData {
  const ImageGenBranchData();
}

class ImageGenRoute extends GoRouteData with $ImageGenRoute {
  const ImageGenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ImageGenPage();
  }
}

class RecordingBranchData extends StatefulShellBranchData {
  const RecordingBranchData();
}

class RecordingRoute extends GoRouteData with $RecordingRoute {
  const RecordingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RecordingPage();
  }
}

class HfModelBranchData extends StatefulShellBranchData {
  const HfModelBranchData();
}

class HfModelRoute extends GoRouteData with $HfModelRoute {
  const HfModelRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HfModelPage();
  }
}

class CorrectorBranchData extends StatefulShellBranchData {
  const CorrectorBranchData();
}

class CorrectorRoute extends GoRouteData with $CorrectorRoute {
  const CorrectorRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CorrectorPage();
  }
}

class PersonasBranchData extends StatefulShellBranchData {
  const PersonasBranchData();
}

class PersonasRoute extends GoRouteData with $PersonasRoute {
  const PersonasRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PersonalitiesPage();
  }
}

class StudyBranchData extends StatefulShellBranchData {
  const StudyBranchData();
}

class StudyRoute extends GoRouteData with $StudyRoute {
  const StudyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StudyPage();
  }
}

class QuizRoute extends GoRouteData with $QuizRoute {
  const QuizRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const QuizPage();
  }
}

class CaptureRoute extends GoRouteData with $CaptureRoute {
  const CaptureRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CapturePage();
  }
}

class ResearchRoute extends GoRouteData with $ResearchRoute {
  const ResearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ResearchPage();
  }
}

class StudyTutorRoute extends GoRouteData with $StudyTutorRoute {
  final String deckName;
  const StudyTutorRoute({
    required this.deckName,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StudyTutorPage(deckName: deckName);
  }
}

class DeckManagerRoute extends GoRouteData with $DeckManagerRoute {
  const DeckManagerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DeckManagerPage();
  }
}

class FocusBranchData extends StatefulShellBranchData {
  const FocusBranchData();
}

class FocusRoute extends GoRouteData with $FocusRoute {
  const FocusRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FocusPage();
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
class SettingsRoute extends GoRouteData with $SettingsRoute {
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

class AccountDetailsRoute extends GoRouteData with $AccountDetailsRoute {
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
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  // Use parent navigator to navigate without bottom bar
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      NavigatorHolder.rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}
//#endregion
