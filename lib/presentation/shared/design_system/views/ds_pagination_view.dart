import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/pagination/pagination_state.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/pagination/pagination_widget.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_content_placeholder_views.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_loading_indicator.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_opacity_gesture_detector.dart';
import 'package:flutter_template/presentation/shared/util/data_state.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';

class DSPaginationView<T, E> extends StatelessWidget {
  final DataState<PaginationState<T, E>, E> state;
  final IndexedItemBuilder<T> indexedItemBuilder;
  final VoidCallback onRefresh;
  final VoidCallback onLoadMore;
  final EdgeInsets? contentPadding;
  final ScrollController? scrollController;

  const DSPaginationView({
    Key? key,
    required this.state,
    required this.indexedItemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    this.contentPadding,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentPadding = this.contentPadding ??
        EdgeInsets.only(
          left: Dimens.marginLarge,
          right: Dimens.marginLarge,
          top: Dimens.marginLarge,
          bottom: context.mediaQuery.padding.bottom,
        );
    return PaginationWidget(
      scrollController: scrollController,
      state: state,
      initialLoadingBuilder: (context) {
        return const Center(
          child: DSLoadingIndicator(),
        );
      },
      initialErrorBuilder: (context, reason) {
        return DSErrorView(
          contentPadding: const EdgeInsets.all(Dimens.marginLarge),
          description: reason.toString(),
          onRefresh: onRefresh,
        );
      },
      emptyListBuilder: (context) {
        return DSEmptyView(
          contentPadding: const EdgeInsets.all(Dimens.marginLarge),
          onAction: onRefresh,
        );
      },
      listPadding: contentPadding,
      indexedItemBuilder: indexedItemBuilder,
      loadMoreLoadingBuilder: (context) {
        return const LoadMoreLoadingIndicator();
      },
      loadMoreErrorBuilder: (context, reason) {
        return LoadMoreErrorIndicator(
          reason: reason.toString(),
          onTap: onLoadMore,
        );
      },
      onLoadMore: onLoadMore,
    );
  }
}

const _paginationIndicatorHeight = Dimens.listItemHeightMedium;

class LoadMoreLoadingIndicator extends StatelessWidget {
  const LoadMoreLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: _paginationIndicatorHeight,
      child: Center(
        child: DSLoadingIndicator(),
      ),
    );
  }
}

class LoadMoreErrorIndicator extends StatelessWidget {
  final String? reason;
  final VoidCallback onTap;

  const LoadMoreErrorIndicator({
    Key? key,
    this.reason,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DSOpacityGestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: _paginationIndicatorHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Dimens.boxSmall,
            Expanded(
              child: Text(
                reason ?? context.l10n.defaultErrorMessage,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            Icon(
              Icons.refresh,
              semanticLabel: context.l10n.refresh,
            ),
            Dimens.boxSmall,
          ],
        ),
      ),
    );
  }
}
