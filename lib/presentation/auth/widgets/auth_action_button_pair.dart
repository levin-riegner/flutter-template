import 'package:flutter/material.dart';

class AuthActionButtonPair extends StatelessWidget {
  final Widget firstChild;
  final Widget secondChild;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? buttonSpacing;

  const AuthActionButtonPair({
    super.key,
    required this.firstChild,
    required this.secondChild,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.buttonSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        firstChild,
        if (buttonSpacing != null) SizedBox(height: buttonSpacing!),
        secondChild,
      ],
    );
  }
}
