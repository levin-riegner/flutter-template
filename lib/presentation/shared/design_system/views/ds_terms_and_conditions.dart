import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DSTermsAndConditions extends StatelessWidget {
  final String text;
  final List<LinkPattern> patterns;

  const DSTermsAndConditions({
    super.key,
    required this.text,
    required this.patterns,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: buildTextSpan(),
    );
  }

  TextSpan buildTextSpan() {
    List<TextSpan> children = [];
    String remainingText = text;

    for (final pattern in patterns) {
      final match = pattern.regex.firstMatch(remainingText);
      if (match != null) {
        final matchedText = match.group(0)!;
        final matchedStart = remainingText.indexOf(matchedText);

        if (matchedStart > 0) {
          children
              .add(TextSpan(text: remainingText.substring(0, matchedStart)));
        }

        children.add(
          TextSpan(
            text: matchedText,
            style: const TextStyle(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()..onTap = pattern.onPressed,
          ),
        );

        remainingText =
            remainingText.substring(matchedStart + matchedText.length);
      }
    }

    if (remainingText.isNotEmpty) {
      children.add(TextSpan(text: remainingText));
    }

    return TextSpan(
      children: children,
    );
  }
}

class LinkPattern {
  final RegExp regex;
  final VoidCallback onPressed;

  LinkPattern({
    required String pattern,
    required this.onPressed,
  }) : regex = RegExp(pattern);
}
