// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'articles_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ArticlesErrorTearOff {
  const _$ArticlesErrorTearOff();

// ignore: unused_element
  Unknown unknown() {
    return const Unknown();
  }
}

/// @nodoc
// ignore: unused_element
const $ArticlesError = _$ArticlesErrorTearOff();

/// @nodoc
mixin _$ArticlesError {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult unknown(),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult unknown(),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult unknown(Unknown value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult unknown(Unknown value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $ArticlesErrorCopyWith<$Res> {
  factory $ArticlesErrorCopyWith(
          ArticlesError value, $Res Function(ArticlesError) then) =
      _$ArticlesErrorCopyWithImpl<$Res>;
}

/// @nodoc
class _$ArticlesErrorCopyWithImpl<$Res>
    implements $ArticlesErrorCopyWith<$Res> {
  _$ArticlesErrorCopyWithImpl(this._value, this._then);

  final ArticlesError _value;
  // ignore: unused_field
  final $Res Function(ArticlesError) _then;
}

/// @nodoc
abstract class $UnknownCopyWith<$Res> {
  factory $UnknownCopyWith(Unknown value, $Res Function(Unknown) then) =
      _$UnknownCopyWithImpl<$Res>;
}

/// @nodoc
class _$UnknownCopyWithImpl<$Res> extends _$ArticlesErrorCopyWithImpl<$Res>
    implements $UnknownCopyWith<$Res> {
  _$UnknownCopyWithImpl(Unknown _value, $Res Function(Unknown) _then)
      : super(_value, (v) => _then(v as Unknown));

  @override
  Unknown get _value => super._value as Unknown;
}

/// @nodoc
class _$Unknown with DiagnosticableTreeMixin implements Unknown {
  const _$Unknown();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ArticlesError.unknown()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'ArticlesError.unknown'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Unknown);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult unknown(),
  }) {
    assert(unknown != null);
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult unknown(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult unknown(Unknown value),
  }) {
    assert(unknown != null);
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult unknown(Unknown value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class Unknown implements ArticlesError {
  const factory Unknown() = _$Unknown;
}
