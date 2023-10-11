import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_state.freezed.dart';

@freezed
sealed class DataState<T, Y> with _$DataState<T, Y> {
  const factory DataState.idle() = Idle<T, Y>;

  const factory DataState.loading() = Loading<T, Y>;

  const factory DataState.success({required T data}) = Success<T, Y>;

  const factory DataState.failure({required Y reason}) = Failure<T, Y>;
}
