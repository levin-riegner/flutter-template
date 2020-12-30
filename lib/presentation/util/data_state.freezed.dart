// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$DataStateTearOff {
  const _$DataStateTearOff();

// ignore: unused_element
  Idle<T, Y> idle<T, Y>() {
    return Idle<T, Y>();
  }

// ignore: unused_element
  Loading<T, Y> loading<T, Y>() {
    return Loading<T, Y>();
  }

// ignore: unused_element
  Success<T, Y> success<T, Y>({@required T data}) {
    return Success<T, Y>(
      data: data,
    );
  }

// ignore: unused_element
  Failure<T, Y> failure<T, Y>({@required Y reason}) {
    return Failure<T, Y>(
      reason: reason,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $DataState = _$DataStateTearOff();

/// @nodoc
mixin _$DataState<T, Y> {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult idle(),
    @required TResult loading(),
    @required TResult success(T data),
    @required TResult failure(Y reason),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult idle(),
    TResult loading(),
    TResult success(T data),
    TResult failure(Y reason),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult idle(Idle<T, Y> value),
    @required TResult loading(Loading<T, Y> value),
    @required TResult success(Success<T, Y> value),
    @required TResult failure(Failure<T, Y> value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult idle(Idle<T, Y> value),
    TResult loading(Loading<T, Y> value),
    TResult success(Success<T, Y> value),
    TResult failure(Failure<T, Y> value),
    @required TResult orElse(),
  });
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
class _$Idle<T, Y> with DiagnosticableTreeMixin implements Idle<T, Y> {
  const _$Idle();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DataState<$T, $Y>.idle()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'DataState<$T, $Y>.idle'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Idle<T, Y>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult idle(),
    @required TResult loading(),
    @required TResult success(T data),
    @required TResult failure(Y reason),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(success != null);
    assert(failure != null);
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult idle(),
    TResult loading(),
    TResult success(T data),
    TResult failure(Y reason),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult idle(Idle<T, Y> value),
    @required TResult loading(Loading<T, Y> value),
    @required TResult success(Success<T, Y> value),
    @required TResult failure(Failure<T, Y> value),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(success != null);
    assert(failure != null);
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult idle(Idle<T, Y> value),
    TResult loading(Loading<T, Y> value),
    TResult success(Success<T, Y> value),
    TResult failure(Failure<T, Y> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
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
class _$Loading<T, Y> with DiagnosticableTreeMixin implements Loading<T, Y> {
  const _$Loading();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DataState<$T, $Y>.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'DataState<$T, $Y>.loading'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Loading<T, Y>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult idle(),
    @required TResult loading(),
    @required TResult success(T data),
    @required TResult failure(Y reason),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(success != null);
    assert(failure != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult idle(),
    TResult loading(),
    TResult success(T data),
    TResult failure(Y reason),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult idle(Idle<T, Y> value),
    @required TResult loading(Loading<T, Y> value),
    @required TResult success(Success<T, Y> value),
    @required TResult failure(Failure<T, Y> value),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(success != null);
    assert(failure != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult idle(Idle<T, Y> value),
    TResult loading(Loading<T, Y> value),
    TResult success(Success<T, Y> value),
    TResult failure(Failure<T, Y> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
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
    Object data = freezed,
  }) {
    return _then(Success<T, Y>(
      data: data == freezed ? _value.data : data as T,
    ));
  }
}

/// @nodoc
class _$Success<T, Y> with DiagnosticableTreeMixin implements Success<T, Y> {
  const _$Success({@required this.data}) : assert(data != null);

  @override
  final T data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DataState<$T, $Y>.success(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DataState<$T, $Y>.success'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Success<T, Y> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(data);

  @override
  $SuccessCopyWith<T, Y, Success<T, Y>> get copyWith =>
      _$SuccessCopyWithImpl<T, Y, Success<T, Y>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult idle(),
    @required TResult loading(),
    @required TResult success(T data),
    @required TResult failure(Y reason),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(success != null);
    assert(failure != null);
    return success(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult idle(),
    TResult loading(),
    TResult success(T data),
    TResult failure(Y reason),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (success != null) {
      return success(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult idle(Idle<T, Y> value),
    @required TResult loading(Loading<T, Y> value),
    @required TResult success(Success<T, Y> value),
    @required TResult failure(Failure<T, Y> value),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(success != null);
    assert(failure != null);
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult idle(Idle<T, Y> value),
    TResult loading(Loading<T, Y> value),
    TResult success(Success<T, Y> value),
    TResult failure(Failure<T, Y> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class Success<T, Y> implements DataState<T, Y> {
  const factory Success({@required T data}) = _$Success<T, Y>;

  T get data;
  $SuccessCopyWith<T, Y, Success<T, Y>> get copyWith;
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
    Object reason = freezed,
  }) {
    return _then(Failure<T, Y>(
      reason: reason == freezed ? _value.reason : reason as Y,
    ));
  }
}

/// @nodoc
class _$Failure<T, Y> with DiagnosticableTreeMixin implements Failure<T, Y> {
  const _$Failure({@required this.reason}) : assert(reason != null);

  @override
  final Y reason;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DataState<$T, $Y>.failure(reason: $reason)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DataState<$T, $Y>.failure'))
      ..add(DiagnosticsProperty('reason', reason));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Failure<T, Y> &&
            (identical(other.reason, reason) ||
                const DeepCollectionEquality().equals(other.reason, reason)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(reason);

  @override
  $FailureCopyWith<T, Y, Failure<T, Y>> get copyWith =>
      _$FailureCopyWithImpl<T, Y, Failure<T, Y>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult idle(),
    @required TResult loading(),
    @required TResult success(T data),
    @required TResult failure(Y reason),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(success != null);
    assert(failure != null);
    return failure(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult idle(),
    TResult loading(),
    TResult success(T data),
    TResult failure(Y reason),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (failure != null) {
      return failure(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult idle(Idle<T, Y> value),
    @required TResult loading(Loading<T, Y> value),
    @required TResult success(Success<T, Y> value),
    @required TResult failure(Failure<T, Y> value),
  }) {
    assert(idle != null);
    assert(loading != null);
    assert(success != null);
    assert(failure != null);
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult idle(Idle<T, Y> value),
    TResult loading(Loading<T, Y> value),
    TResult success(Success<T, Y> value),
    TResult failure(Failure<T, Y> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class Failure<T, Y> implements DataState<T, Y> {
  const factory Failure({@required Y reason}) = _$Failure<T, Y>;

  Y get reason;
  $FailureCopyWith<T, Y, Failure<T, Y>> get copyWith;
}
