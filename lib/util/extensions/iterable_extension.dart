extension IterableExtension<E> on Iterable<E> {
  E? get firstOrNull {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }
}

extension IterableNullableExtension<E> on Iterable<E>? {
  List<E>? orEmpty() {
    if (this == null) return List.empty();
    return this as List<E>;
  }

  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
