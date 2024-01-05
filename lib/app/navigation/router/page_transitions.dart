import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

abstract class PageTransitions {
  //#region Shared Axis
  static CustomTransitionPage sharedAxisY({
    LocalKey? key,
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return _sharedAxis(
      key: key,
      context: context,
      state: state,
      child: child,
      type: SharedAxisTransitionType.vertical,
    );
  }

  static CustomTransitionPage sharedAxisX({
    LocalKey? key,
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return _sharedAxis(
      key: key,
      context: context,
      state: state,
      child: child,
      type: SharedAxisTransitionType.horizontal,
    );
  }

  static CustomTransitionPage sharedAxisZ({
    LocalKey? key,
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return _sharedAxis(
      key: key,
      context: context,
      state: state,
      child: child,
      type: SharedAxisTransitionType.scaled,
    );
  }

  static CustomTransitionPage _sharedAxis({
    LocalKey? key,
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    required SharedAxisTransitionType type,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
          fillColor: context.colorScheme.background,
          child: child,
        );
      },
    );
  }
  //#endregion

  //#region Fade Through
  static CustomTransitionPage fadeThrough({
    LocalKey? key,
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          fillColor: context.colorScheme.background,
          child: child,
        );
      },
    );
  }
  //#endregion
}
