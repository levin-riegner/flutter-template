// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$DataStateTearOff {
  const _$DataStateTearOff();

  Idle<T, Y> idle<T, Y>() {
    return Idle<T, Y>();
  }

  Loading<T, Y> loading<T, Y>() {
    return Loading<T, Y>();
  }

  Success<T, Y> success<T, Y>({required T data}) {
    return Success<T, Y>(
      data: data,
    );
  }

  Failure<T, Y> failure<T, Y>({required Y reason}) {
    return Failure<T, Y>(
      reason: reason,
    );
  }
}

/// @nodoc
const $DataState = _$DataStateTearOff();

/// @nodoc
mixin _$DataState<T, Y> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(Y reason) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(Y reason)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(Y reason)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T, Y> value) idle,
    required TResult Function(Loading<T, Y> value) loading,
    required TResult Function(Success<T, Y> value) success,
    required TResult Function(Failure<T, Y> value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Idle<T, Y> value)? idle,
    TResult Function(Loading<T, Y> value)? loading,
    TResult Function(Success<T, Y> value)? success,
    TResult Function(Failure<T, Y> value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T, Y> value)? idle,
    TResult Function(Loading<T, Y> value)? loading,
    TResult Function(Success<T, Y> value)? success,
    TResult Function(Failure<T, Y> value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataStateCopyWith<T, Y, $Res> {
  factory $DataStateCopyWith(
          DataState<T, Y> value, $Res Function(DataState<T, Y>) then) =
      _$DataStateCopyWithImpl<T, Y, $Res>;
}

/// @nodoc
class _$DataStateCopyWithImpl<T, Y, $Res>
    implements $DataStateCopyWith<T, Y, $Res> {
  _$DataStateCopyWithImpl(this._value, this._then);

  final DataState<T, Y> _value;
  // ignore: unused_field
  final $Res Function(DataState<T, Y>) _then;
}

/// @nodoc
abstract class $IdleCopyWith<T, Y, $Res> {
  factory $IdleCopyWith(Idle<T, Y> value, $Res Function(Idle<T, Y>) then) =
      _$IdleCopyWithImpl<T, Y, $Res>;
}

/// @nodoc
class _$IdleCopyWithImpl<T, Y, $Res> extends _$DataStateCopyWithImpl<T, Y, $Res>
    implements $IdleCopyWith<T, Y, $Res> {
  _$IdleCopyWithImpl(Idle<T, Y> _value, $Res Function(Idle<T, Y>) _then)
      : super(_value, (v) => _then(v as Idle<T, Y>));

  @override
  Idle<T, Y> get _value => super._value as Idle<T, Y>;
}

/// @nodoc

class _$Idle<T, Y> implements Idle<T, Y> {
  const _$Idle();

  @override
  String toString() {
    return 'DataState<$T, $Y>.idle()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Idle<T, Y>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(Y reason) failure,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(Y reason)? failure,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(Y reason)? failure,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T, Y> value) idle,
    required TResult Function(Loading<T, Y> value) loading,
    required TResult Function(Success<T, Y> value) success,
    required TResult Function(Failure<T, Y> value) failure,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Idle<T, Y> value)? idle,
    TResult Function(Loading<T, Y> value)? loading,
    TResult Function(Success<T, Y> value)? success,
    TResult Function(Failure<T, Y> value)? failure,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T, Y> value)? idle,
    TResult Function(Loading<T, Y> value)? loading,
    TResult Function(Success<T, Y> value)? success,
    TResult Function(Failure<T, Y> value)? failure,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class Idle<T, Y> implements DataState<T, Y> {
  const factory Idle() = _$Idle<T, Y>;
}

/// @nodoc
abstract class $LoadingCopyWith<T, Y, $Res> {
  factory $LoadingCopyWith(
          Loading<T, Y> value, $Res Function(Loading<T, Y>) then) =
      _$LoadingCopyWithImpl<T, Y, $Res>;
}

/// @nodoc
class _$LoadingCopyWithImpl<T, Y, $Res>
    extends _$DataStateCopyWithImpl<T, Y, $Res>
    implements $LoadingCopyWith<T, Y, $Res> {
  _$LoadingCopyWithImpl(
      Loading<T, Y> _value, $Res Function(Loading<T, Y>) _then)
      : super(_value, (v) => _then(v as Loading<T, Y>));

  @override
  Loading<T, Y> get _value => super._value as Loading<T, Y>;
}

/// @nodoc

class _$Loading<T, Y> implements Loading<T, Y> {
  const _$Loading();

  @override
  String toString() {
    return 'DataState<$T, $Y>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Loading<T, Y>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(Y reason) failure,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(Y reason)? failure,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(Y reason)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T, Y> value) idle,
    required TResult Function(Loading<T, Y> value) loading,
    required TResult Function(Success<T, Y> value) success,
    required TResult Function(Failure<T, Y> value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Idle<T, Y> value)? idle,
    TResult Function(Loading<T, Y> value)? loading,
    TResult Function(Success<T, Y> value)? success,
    TResult Function(Failure<T, Y> value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T, Y> value)? idle,
    TResult Function(Loading<T, Y> value)? loading,
    TResult Function(Success<T, Y> value)? success,
    TResult Function(Failure<T, Y> value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading<T, Y> implements DataState<T, Y> {
  const factory Loading() = _$Loading<T, Y>;
}

/// @nodoc
abstract class $SuccessCopyWith<T, Y, $Res> {
  factory $SuccessCopyWith(
          Success<T, Y> value, $Res Function(Success<T, Y>) then) =
      _$SuccessCopyWithImpl<T, Y, $Res>;
  $Res call({T data});
}

/// @nodoc
class _$SuccessCopyWithImpl<T, Y, $Res>
    extends _$DataStateCopyWithImpl<T, Y, $Res>
    implements $SuccessCopyWith<T, Y, $Res> {
  _$SuccessCopyWithImpl(
      Success<T, Y> _value, $Res Function(Success<T, Y>) _then)
      : super(_value, (v) => _then(v as Success<T, Y>));

  @override
  Success<T, Y> get _value => super._value as Success<T, Y>;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(Success<T, Y>(
      data: data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$Success<T, Y> implements Success<T, Y> {
  const _$Success({required this.data});

  @override
  final T data;

  @override
  String toString() {
    return 'DataState<$T, $Y>.success(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Success<T, Y> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  $SuccessCopyWith<T, Y, Success<T, Y>> get copyWith =>
      _$SuccessCopyWithImpl<T, Y, Success<T, Y>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(Y reason) failure,
  }) {
    return success(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(Y reason)? failure,
  }) {
    return success?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(Y reason)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T, Y> value) idle,
    required TResult Function(Loading<T, Y> value) loading,
    required TResult Function(Success<T, Y> value) success,
    required TResult Function(Failure<T, Y> value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Idle<T, Y> value)? idle,
    TResult Function(Loading<T, Y> value)? loading,
    TResult Function(Success<T, Y> value)? success,
    TResult Function(Failure<T, Y> value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T, Y> value)? idle,
    TResult Function(Loading<T, Y> value)? loading,
    TResult Function(Success<T, Y> value)? success,
    TResult Function(Failure<T, Y> value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class Success<T, Y> implements DataState<T, Y> {
  const factory Success({required T data}) = _$Success<T, Y>;

  T get data;
  @JsonKey(ignore: true)
  $SuccessCopyWith<T, Y, Success<T, Y>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<T, Y, $Res> {
  factory $FailureCopyWith(
          Failure<T, Y> value, $Res Function(Failure<T, Y>) then) =
      _$FailureCopyWithImpl<T, Y, $Res>;
  $Res call({Y reason});
}

/// @nodoc
class _$FailureCopyWithImpl<T, Y, $Res>
    extends _$DataStateCopyWithImpl<T, Y, $Res>
    implements $FailureCopyWith<T, Y, $Res> {
  _$FailureCopyWithImpl(
      Failure<T, Y> _value, $Res Function(Failure<T, Y>) _then)
      : super(_value, (v) => _then(v as Failure<T, Y>));

  @override
  Failure<T, Y> get _value => super._value as Failure<T, Y>;

  @override
  $Res call({
    Object? reason = freezed,
  }) {
    return _then(Failure<T, Y>(
      reason: reason == freezed
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as Y,
    ));
  }
}

/// @nodoc

class _$Failure<T, Y> implements Failure<T, Y> {
  const _$Failure({required this.reason});

  @override
  final Y reason;

  @override
  String toString() {
    return 'DataState<$T, $Y>.failure(reason: $reason)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Failure<T, Y> &&
            const DeepCollectionEquality().equals(other.reason, reason));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(reason));

  @JsonKey(ignore: true)
  @override
  $FailureCopyWith<T, Y, Failure<T, Y>> get copyWith =>
      _$FailureCopyWithImpl<T, Y, Failure<T, Y>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(Y reason) failure,
  }) {
    return failure(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(Y reason)? failure,
  }) {
    return failure?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(Y reason)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle<T, Y> value) idle,
    required TResult Function(Loading<T, Y> value) loading,
    required TResult Function(Success<T, Y> value) success,
    required TResult Function(Failure<T, Y> value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Idle<T, Y> value)? idle,
    TResult Function(Loading<T, Y> value)? loading,
    TResult Function(Success<T, Y> value)? success,
    TResult Function(Failure<T, Y> value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle<T, Y> value)? idle,
    TResult Function(Loading<T, Y> value)? loading,
    TResult Function(Success<T, Y> value)? success,
    TResult Function(Failure<T, Y> value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class Failure<T, Y> implements DataState<T, Y> {
  const factory Failure({required Y reason}) = _$Failure<T, Y>;

  Y get reason;
  @JsonKey(ignore: true)
  $FailureCopyWith<T, Y, Failure<T, Y>> get copyWith =>
      throw _privateConstructorUsedError;
}
