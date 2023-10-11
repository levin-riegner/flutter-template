extension StringExtension on String {
  String takeLast(int? count) {
    if (count == null || count < 0) return this;
    if (length <= count) {
      return this;
    } else {
      return substring(length - count);
    }
  }
}

extension StringNullableExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
