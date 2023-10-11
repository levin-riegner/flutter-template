import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_state.freezed.dart';

class PaginationState<T, E> extends Equatable {
  final List<T> items;
  final LoadMoreState<E> loadMoreState;

  const PaginationState({
    required this.items,
    required this.loadMoreState,
  });

  @override
  List<Object?> get props => [
        items,
        loadMoreState,
      ];

  PaginationState<T, E> copyWith({
    List<T>? items,
    LoadMoreState<E>? loadMoreState,
  }) {
    return PaginationState<T, E>(
      items: items ?? this.items,
      loadMoreState: loadMoreState ?? this.loadMoreState,
    );
  }
}

@freezed
sealed class LoadMoreState<E> with _$LoadMoreState<E> {
  const factory LoadMoreState.idle({
    required bool hasReachedMax,
  }) = LoadMoreIdle<E>;

  const factory LoadMoreState.loading() = LoadMoreLoading<E>;

  const factory LoadMoreState.error({
    required E reason,
  }) = LoadMoreError<E>;
}
