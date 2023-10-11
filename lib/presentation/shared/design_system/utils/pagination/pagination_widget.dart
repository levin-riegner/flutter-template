import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/pagination/pagination_state.dart';
import 'package:flutter_template/presentation/shared/util/data_state.dart';
import 'package:flutter_template/presentation/shared/util/throttler.dart';

typedef IndexedItemBuilder<T> = Widget Function(
    BuildContext context, int index, T item, bool isBottom);

class PaginationWidget<T, E> extends StatelessWidget {
  static const double defaultScrollLoadMoreThreshold = 0.8;

  // Scroll Configuration
  final double scrollLoadMoreThreshold;
  final ScrollController? scrollController;
  // Data state
  final DataState<PaginationState<T, E>, E> state;
  // Initial widgets
  final Widget Function(BuildContext)? initialIdleBuilder;
  final Widget Function(BuildContext) initialLoadingBuilder;
  final Widget Function(BuildContext, E) initialErrorBuilder;
  // List widget
  final Widget Function(BuildContext) emptyListBuilder;
  final IndexedItemBuilder<T> indexedItemBuilder;
  final EdgeInsets? listPadding;
  // Load more widgets
  final Widget Function(BuildContext) loadMoreLoadingBuilder;
  final Widget Function(BuildContext, E) loadMoreErrorBuilder;
  // Load more callback
  final VoidCallback onLoadMore;

  const PaginationWidget({
    Key? key,
    required this.state,
    this.initialIdleBuilder,
    required this.initialLoadingBuilder,
    required this.initialErrorBuilder,
    required this.emptyListBuilder,
    required this.indexedItemBuilder,
    this.listPadding,
    required this.loadMoreLoadingBuilder,
    required this.loadMoreErrorBuilder,
    required this.onLoadMore,
    this.scrollLoadMoreThreshold = defaultScrollLoadMoreThreshold,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      Idle() => initialIdleBuilder?.call(context) ?? Container(),
      Loading() => initialLoadingBuilder(context),
      Failure(:final reason) => initialErrorBuilder(context, reason),
      Success(:final data) => data.items.isEmpty
          ? emptyListBuilder(context)
          : PagedListView(
              scrollController: scrollController,
              padding: listPadding,
              indexedItemBuilder: indexedItemBuilder,
              data: data,
              loadMoreLoadingBuilder: loadMoreLoadingBuilder,
              loadMoreErrorBuilder: loadMoreErrorBuilder,
              onLoadMore: onLoadMore,
              scrollLoadMoreThreshold: scrollLoadMoreThreshold,
            ),
    };
  }
}

class PagedListView<T, E> extends StatelessWidget {
  final Throttler _throttler = Throttler(throttleGapMs: 200);

  final IndexedItemBuilder<T> indexedItemBuilder;
  final PaginationState<T, E> data;
  final Widget Function(BuildContext) loadMoreLoadingBuilder;
  final Widget Function(BuildContext, E) loadMoreErrorBuilder;
  final VoidCallback onLoadMore;

  final ScrollController? scrollController;
  final EdgeInsets? padding;
  final double scrollLoadMoreThreshold;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  PagedListView({
    Key? key,
    required this.indexedItemBuilder,
    required this.data,
    required this.loadMoreLoadingBuilder,
    required this.loadMoreErrorBuilder,
    required this.onLoadMore,
    this.scrollController,
    this.padding,
    this.scrollLoadMoreThreshold =
        PaginationWidget.defaultScrollLoadMoreThreshold,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  }) : super(key: key);

  bool _isBottom(ScrollEndNotification scrollInfo) {
    final maxScroll = scrollInfo.metrics.maxScrollExtent;
    final currentScroll = scrollInfo.metrics.pixels;
    return currentScroll >= (maxScroll * scrollLoadMoreThreshold);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollInfo) {
        // Listen to scroll end
        if (!_isBottom(scrollInfo)) {
          return false;
        }
        final hasReachedMaxItems = switch (data.loadMoreState) {
          LoadMoreIdle(:final hasReachedMax) => hasReachedMax,
          _ => true,
        };
        if (!hasReachedMaxItems) {
          // Load more items
          _throttler.run(onLoadMore);
        }
        return true;
      },
      child: ListView.builder(
        controller: scrollController,
        padding: padding,
        keyboardDismissBehavior: keyboardDismissBehavior,
        itemCount: data.items.length +
            (switch (data.loadMoreState) {
              LoadMoreIdle(:final hasReachedMax) => hasReachedMax ? 0 : 1,
              LoadMoreLoading() => 1,
              LoadMoreError() => 1,
            }),
        itemBuilder: (context, index) {
          if (index == data.items.length) {
            return switch (data.loadMoreState) {
              LoadMoreIdle() => IgnorePointer(
                  child: Opacity(
                    opacity: 0,
                    child: loadMoreLoadingBuilder(context),
                  ),
                ),
              LoadMoreLoading() => loadMoreLoadingBuilder(context),
              LoadMoreError(:final reason) =>
                loadMoreErrorBuilder(context, reason),
            };
          }
          return indexedItemBuilder(
            context,
            index,
            data.items[index],
            index == data.items.length - 1,
          );
        },
      ),
    );
  }
}
