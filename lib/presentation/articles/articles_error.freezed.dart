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
  Blacklisted<T, Y> blacklisted<T, Y>() {
    return Blacklisted<T, Y>();
  }

// ignore: unused_element
  SubscriptionExpired<T, Y> subscriptionExpired<T, Y>() {
    return SubscriptionExpired<T, Y>();
  }
}

/// @nodoc
// ignore: unused_element
const $ArticlesError = _$ArticlesErrorTearOff();

/// @nodoc
mixin _$ArticlesError<T, Y> {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult blacklisted(),
    @required TResult subscriptionExpired(),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult blacklisted(),
    TResult subscriptionExpired(),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult blacklisted(Blacklisted<T, Y> value),
    @required TResult subscriptionExpired(SubscriptionExpired<T, Y> value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult blacklisted(Blacklisted<T, Y> value),
    TResult subscriptionExpired(SubscriptionExpired<T, Y> value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $ArticlesErrorCopyWith<T, Y, $Res> {
  factory $ArticlesErrorCopyWith(
          ArticlesError<T, Y> value, $Res Function(ArticlesError<T, Y>) then) =
      _$ArticlesErrorCopyWithImpl<T, Y, $Res>;
}

/// @nodoc
class _$ArticlesErrorCopyWithImpl<T, Y, $Res>
    implements $ArticlesErrorCopyWith<T, Y, $Res> {
  _$ArticlesErrorCopyWithImpl(this._value, this._then);

  final ArticlesError<T, Y> _value;
  // ignore: unused_field
  final $Res Function(ArticlesError<T, Y>) _then;
}

/// @nodoc
abstract class $BlacklistedCopyWith<T, Y, $Res> {
  factory $BlacklistedCopyWith(
          Blacklisted<T, Y> value, $Res Function(Blacklisted<T, Y>) then) =
      _$BlacklistedCopyWithImpl<T, Y, $Res>;
}

/// @nodoc
class _$BlacklistedCopyWithImpl<T, Y, $Res>
    extends _$ArticlesErrorCopyWithImpl<T, Y, $Res>
    implements $BlacklistedCopyWith<T, Y, $Res> {
  _$BlacklistedCopyWithImpl(
      Blacklisted<T, Y> _value, $Res Function(Blacklisted<T, Y>) _then)
      : super(_value, (v) => _then(v as Blacklisted<T, Y>));

  @override
  Blacklisted<T, Y> get _value => super._value as Blacklisted<T, Y>;
}

/// @nodoc
class _$Blacklisted<T, Y>
    with DiagnosticableTreeMixin
    implements Blacklisted<T, Y> {
  const _$Blacklisted();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ArticlesError<$T, $Y>.blacklisted()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ArticlesError<$T, $Y>.blacklisted'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Blacklisted<T, Y>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult blacklisted(),
    @required TResult subscriptionExpired(),
  }) {
    assert(blacklisted != null);
    assert(subscriptionExpired != null);
    return blacklisted();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult blacklisted(),
    TResult subscriptionExpired(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (blacklisted != null) {
      return blacklisted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult blacklisted(Blacklisted<T, Y> value),
    @required TResult subscriptionExpired(SubscriptionExpired<T, Y> value),
  }) {
    assert(blacklisted != null);
    assert(subscriptionExpired != null);
    return blacklisted(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult blacklisted(Blacklisted<T, Y> value),
    TResult subscriptionExpired(SubscriptionExpired<T, Y> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (blacklisted != null) {
      return blacklisted(this);
    }
    return orElse();
  }
}

abstract class Blacklisted<T, Y> implements ArticlesError<T, Y> {
  const factory Blacklisted() = _$Blacklisted<T, Y>;
}

/// @nodoc
abstract class $SubscriptionExpiredCopyWith<T, Y, $Res> {
  factory $SubscriptionExpiredCopyWith(SubscriptionExpired<T, Y> value,
          $Res Function(SubscriptionExpired<T, Y>) then) =
      _$SubscriptionExpiredCopyWithImpl<T, Y, $Res>;
}

/// @nodoc
class _$SubscriptionExpiredCopyWithImpl<T, Y, $Res>
    extends _$ArticlesErrorCopyWithImpl<T, Y, $Res>
    implements $SubscriptionExpiredCopyWith<T, Y, $Res> {
  _$SubscriptionExpiredCopyWithImpl(SubscriptionExpired<T, Y> _value,
      $Res Function(SubscriptionExpired<T, Y>) _then)
      : super(_value, (v) => _then(v as SubscriptionExpired<T, Y>));

  @override
  SubscriptionExpired<T, Y> get _value =>
      super._value as SubscriptionExpired<T, Y>;
}

/// @nodoc
class _$SubscriptionExpired<T, Y>
    with DiagnosticableTreeMixin
    implements SubscriptionExpired<T, Y> {
  const _$SubscriptionExpired();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ArticlesError<$T, $Y>.subscriptionExpired()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty(
          'type', 'ArticlesError<$T, $Y>.subscriptionExpired'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is SubscriptionExpired<T, Y>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult blacklisted(),
    @required TResult subscriptionExpired(),
  }) {
    assert(blacklisted != null);
    assert(subscriptionExpired != null);
    return subscriptionExpired();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult blacklisted(),
    TResult subscriptionExpired(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (subscriptionExpired != null) {
      return subscriptionExpired();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult blacklisted(Blacklisted<T, Y> value),
    @required TResult subscriptionExpired(SubscriptionExpired<T, Y> value),
  }) {
    assert(blacklisted != null);
    assert(subscriptionExpired != null);
    return subscriptionExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult blacklisted(Blacklisted<T, Y> value),
    TResult subscriptionExpired(SubscriptionExpired<T, Y> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (subscriptionExpired != null) {
      return subscriptionExpired(this);
    }
    return orElse();
  }
}

abstract class SubscriptionExpired<T, Y> implements ArticlesError<T, Y> {
  const factory SubscriptionExpired() = _$SubscriptionExpired<T, Y>;
}
