import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/app/resources/assets.dart';
import 'package:logging_flutter/flogger.dart';

// Optional splash screen to show an animation
class SplashScreen extends StatefulWidget {
  final String initialRoute;

  SplashScreen(this.initialRoute);

  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<SplashScreen> with TickerProviderStateMixin {
  static const _kLaunchDurationInMs = 3000;
  AnimationController _opacityController;

  @override
  void initState() {
    super.initState();
    _opacityController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..forward();
    Timer(Duration(milliseconds: _kLaunchDurationInMs), () {
      Flogger.info("Launch Completed");
      Navigator.of(context)
          .pushNamedAndRemoveUntil(widget.initialRoute, (_) => false);
    });
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final animation = FadeTransition(
      opacity: _opacityController.drive(CurveTween(curve: Curves.easeOut)),
      child: Container(),
      // TODO: Add animation or logo
      // FlareActor(
      //   "assets/animations/launch.flr",
      //   alignment: Alignment.center,
      //   fit: BoxFit.contain,
      //   color: ThemeProvider.theme.colors.secondary,
      //   animation: "Droplette_Animation_Launch",
      // ),
    );

    final launchImage = FadeTransition(
      opacity: _opacityController.drive(CurveTween(curve: Curves.easeOut)),
      child: Image.asset(Assets.launchImage),
    );

    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      ),
      SizedBox(
        width: width,
        height: height,
        child: animation,
      ),
      Center(
        child: launchImage,
      ),
    ]);
  }
}
