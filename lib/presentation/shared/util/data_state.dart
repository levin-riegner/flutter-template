import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_state.freezed.dart';

@freezed
class DataState<T, Y> with _$DataState<T, Y> {
  const factory DataState.idle() = _Idle<T, Y>;

  const factory DataState.loading() = _Loading<T, Y>;

  const factory DataState.success({required T data}) = _Success<T, Y>;

  const factory DataState.failure({required Y reason}) = _Failure<T, Y>;
}
