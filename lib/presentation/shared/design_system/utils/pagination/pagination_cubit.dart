import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/data/shared/model/pagination/paginated.dart';
import 'package:flutter_template/data/shared/model/pagination/paginated_request.dart';
import 'package:flutter_template/data/shared/model/pagination/pagination_model.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/pagination/pagination_state.dart';
import 'package:flutter_template/presentation/shared/util/data_state.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:meta/meta.dart';

abstract class PaginationCubit<T, E>
    extends Cubit<DataState<PaginationState<T, E>, E>> {
  PaginationCubit() : super(const DataState.idle());

  PaginationModel? _pagination;

  /// Load data from the repository
  /// No need to handle exceptions, they are already handled by this class
  @visibleForOverriding
  Future<Paginated<T>> loadData(int page);

  /// Map a data exception to a UI error
  @visibleForOverriding
  E mapToError(Object exception);

  CancelableOperation<Paginated<T>>? _currentRefresh;
  Future<void> refresh({
    List<T>? initialData,
    bool showLoading = true,
  }) async {
    Flogger.i("Refresh data");
    // Cancel any previous refresh
    _currentRefresh?.cancel();
    // Emit initial data if provided before refreshing
    if (initialData?.isNotEmpty == true) {
      emit(
        DataState.success(
          data: PaginationState(
            items: initialData!,
            loadMoreState: const LoadMoreState.idle(hasReachedMax: true),
          ),
        ),
      );
    } else if (showLoading) {
      // Otherwise, emit loading
      emit(const DataState.loading());
    }
    try {
      _currentRefresh = CancelableOperation.fromFuture(
        loadData(PaginatedRequest.initialPage),
        onCancel: () => _currentRefresh = null,
      );
      final response = await _currentRefresh?.value;
      if (response == null) return;
      _pagination = response.pagination;
      emit(
        DataState.success(
          data: PaginationState(
            items: response.data ?? [],
            loadMoreState: LoadMoreState.idle(
              hasReachedMax: _pagination?.isLast == true,
            ),
          ),
        ),
      );
    } catch (e) {
      Flogger.w("Error refreshing data: $e");
      emit(DataState.failure(reason: mapToError(e)));
    }
  }

  Future<void> loadMore() async {
    if (this.state is! Success) {
      Flogger.w("Invalid state: ${this.state}");
      return;
    }
    final state = this.state as Success<PaginationState<T, E>, E>;
    if (state.data.loadMoreState is LoadMoreLoading) {
      Flogger.i("Already loading more");
      return;
    }
    // Ensure we can load more
    if (_pagination?.isLast == true) {
      Flogger.i("Reached max pages");
      emit(
        state.copyWith(
          data: state.data.copyWith(
            loadMoreState: const LoadMoreState.idle(hasReachedMax: true),
          ),
        ),
      );
      return;
    }
    // Emit loading
    emit(
      state.copyWith(
        data: state.data.copyWith(
          loadMoreState: const LoadMoreState.loading(),
        ),
      ),
    );
    try {
      final nextPage = (_pagination?.currentPage ?? 0) + 1;
      Flogger.i("Loading more data for page $nextPage");
      final response = await loadData(nextPage);
      // Update current pagination
      _pagination = response.pagination;
      // Update state
      emit(
        state.copyWith(
          data: state.data.copyWith(
            items: [...state.data.items, ...response.data ?? []],
            loadMoreState: LoadMoreState.idle(
              hasReachedMax: _pagination?.isLast == true,
            ),
          ),
        ),
      );
    } catch (e) {
      Flogger.w("Error loading more: $e");
      emit(
        state.copyWith(
          data: state.data.copyWith(
            loadMoreState: LoadMoreState.error(reason: mapToError(e)),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _currentRefresh?.cancel();
    return super.close();
  }
}
