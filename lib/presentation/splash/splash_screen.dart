import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/util/tools/flogger.dart';
import 'package:lr_design_system/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  final bool hasSessionAvailable;

  SplashScreen({@required this.hasSessionAvailable});

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
      Navigator.of(context).pushNamedAndRemoveUntil(widget.hasSessionAvailable ? Routes.articles : "login", (route) => false);
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

    // final backgroundGradient = LinearGradient(
    //   begin: Alignment.bottomCenter,
    //   colors: [AppColors.primaryGradientBottom, AppColors.primaryGradientTop],
    // );

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
      child: Image.asset("assets/images/graphics/launchImage.png"),
    );

    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(color: ThemeProvider.theme.colors.primary),
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
