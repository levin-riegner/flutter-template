import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// This mixin provides a pop method that will pop the current route
/// if possible, otherwise it will go to the root route.
///
/// This is useful for pages that should not close the app when the
/// back button is pressed, but instead should go to the root route.
mixin PoppableMixin {
  void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go("/");
    }
  }

  Future<bool> onWillPop(BuildContext context) async {
    pop(context);
    return false;
  }
}
