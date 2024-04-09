import 'package:flutter/material.dart';

class AuthActionButtonPair extends StatelessWidget {
  final Widget firstChild;
  final Widget secondChild;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  const AuthActionButtonPair({
    super.key,
    required this.firstChild,
    required this.secondChild,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        firstChild,
        secondChild,
      ],
    );
  }
}
