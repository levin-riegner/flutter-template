import 'package:flutter/material.dart';

extension StringExtension on String {
  String takeLast(int? count) {
    if (count == null || count < 0) return this;
    if (length <= count) {
      return this;
    } else {
      return this.substring(length - count);
    }
  }

  String get correctedOverflow => Characters(this)
      .replaceAll(Characters(''), Characters('\u{200B}'))
      .toString();

  String sanitizeHtmlText() {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return replaceAll(exp, '');
  }
}

extension StringNullableExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
