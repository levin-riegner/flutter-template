import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/app/navigation/router.dart' as app;
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/integrations/analytics.dart';
import 'package:lr_design_system/theme/theme.dart';

class App extends StatefulWidget {
  final bool isSessionAvailable;
  final app.Router router = app.Router();

  App({
    Key key,
    @required this.isSessionAvailable,
  })  : assert(isSessionAvailable != null),
        super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final environment = getIt.get<Environment>();
    return MaterialApp(
      // Localization
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        Strings.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: Strings.supportedLocales,
      theme: ThemeProvider.theme.toThemeData(),
      onGenerateRoute: widget.router.generate,
      navigatorObservers: [
        if (kReleaseMode)
          FirebaseAnalyticsObserver(
            analytics: Analytics.firebaseAnalytics,
          ),
      ],
      navigatorKey: NavigatorHolder.navigatorKey,
      home: environment.isInternal ? Banner(
        location: BannerLocation.topEnd,
        message: environment.name,
        child: HomeWidget(),
      ) : HomeWidget(),
    );
    // return BlocProvider<NavigationBloc>(
    //   builder: (_, bloc) => bloc ?? NavigationBloc(navigatorKey: navigatorKey),
    //   onDispose: (_, bloc) => bloc.dispose(),
    //   child: MaterialApp(
    //     // Localization
    //     debugShowCheckedModeBanner: true,
    //     localizationsDelegates: [
    //       // ... app-specific localization delegate[s] here
    //       AppLocalizations.delegate,
    //       GlobalMaterialLocalizations.delegate,
    //       GlobalWidgetsLocalizations.delegate,
    //       GlobalCupertinoLocalizations.delegate,
    //     ],
    //     supportedLocales: [
    //       const Locale('en'),
    //     ],
    //     // Theming
    //     theme: AppTheme.buildDropletteTheme(),
    //     // Routes
    //     onGenerateRoute: _router.getRoute,
    //     navigatorObservers: [
    //       if (kReleaseMode)
    //         FirebaseAnalyticsObserver(
    //             analytics: Analytics.instance().firebaseAnalytics),
    //       _router.routeObserver,
    //     ],
    //     navigatorKey: navigatorKey,
    //     home: SplashScreen(hasSessionAvailable: widget.hasSessionAvailable),
    //   ),
    // );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).helloWorld),
      ),
      body: Center(
        child: Text(
          Strings.of(context).helloWorld,
        ),
      ),
    );
  }
}
