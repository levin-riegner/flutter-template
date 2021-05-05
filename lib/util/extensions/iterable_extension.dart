extension IterableExtension<E> on Iterable<E> {
  E get firstOrNull {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }

  List<E> orEmpty() {
    if (this == null) return List.empty();
    return this;
  }

  bool get isNullOrEmpty => this == null || this.isEmpty;
}
