// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'articles_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ArticlesStateTearOff {
  const _$ArticlesStateTearOff();

  SubscriptionExpired subscriptionExpired() {
    return const SubscriptionExpired();
  }

  Content content({required DataState<List<Article>, DataError> articles}) {
    return Content(
      articles: articles,
    );
  }
}

/// @nodoc
const $ArticlesState = _$ArticlesStateTearOff();

/// @nodoc
mixin _$ArticlesState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() subscriptionExpired,
    required TResult Function(DataState<List<Article>, DataError> articles)
        content,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? subscriptionExpired,
    TResult Function(DataState<List<Article>, DataError> articles)? content,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? subscriptionExpired,
    TResult Function(DataState<List<Article>, DataError> articles)? content,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SubscriptionExpired value) subscriptionExpired,
    required TResult Function(Content value) content,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SubscriptionExpired value)? subscriptionExpired,
    TResult Function(Content value)? content,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubscriptionExpired value)? subscriptionExpired,
    TResult Function(Content value)? content,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticlesStateCopyWith<$Res> {
  factory $ArticlesStateCopyWith(
          ArticlesState value, $Res Function(ArticlesState) then) =
      _$ArticlesStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$ArticlesStateCopyWithImpl<$Res>
    implements $ArticlesStateCopyWith<$Res> {
  _$ArticlesStateCopyWithImpl(this._value, this._then);

  final ArticlesState _value;
  // ignore: unused_field
  final $Res Function(ArticlesState) _then;
}

/// @nodoc
abstract class $SubscriptionExpiredCopyWith<$Res> {
  factory $SubscriptionExpiredCopyWith(
          SubscriptionExpired value, $Res Function(SubscriptionExpired) then) =
      _$SubscriptionExpiredCopyWithImpl<$Res>;
}

/// @nodoc
class _$SubscriptionExpiredCopyWithImpl<$Res>
    extends _$ArticlesStateCopyWithImpl<$Res>
    implements $SubscriptionExpiredCopyWith<$Res> {
  _$SubscriptionExpiredCopyWithImpl(
      SubscriptionExpired _value, $Res Function(SubscriptionExpired) _then)
      : super(_value, (v) => _then(v as SubscriptionExpired));

  @override
  SubscriptionExpired get _value => super._value as SubscriptionExpired;
}

/// @nodoc

class _$SubscriptionExpired implements SubscriptionExpired {
  const _$SubscriptionExpired();

  @override
  String toString() {
    return 'ArticlesState.subscriptionExpired()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SubscriptionExpired);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() subscriptionExpired,
    required TResult Function(DataState<List<Article>, DataError> articles)
        content,
  }) {
    return subscriptionExpired();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? subscriptionExpired,
    TResult Function(DataState<List<Article>, DataError> articles)? content,
  }) {
    return subscriptionExpired?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? subscriptionExpired,
    TResult Function(DataState<List<Article>, DataError> articles)? content,
    required TResult orElse(),
  }) {
    if (subscriptionExpired != null) {
      return subscriptionExpired();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SubscriptionExpired value) subscriptionExpired,
    required TResult Function(Content value) content,
  }) {
    return subscriptionExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SubscriptionExpired value)? subscriptionExpired,
    TResult Function(Content value)? content,
  }) {
    return subscriptionExpired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubscriptionExpired value)? subscriptionExpired,
    TResult Function(Content value)? content,
    required TResult orElse(),
  }) {
    if (subscriptionExpired != null) {
      return subscriptionExpired(this);
    }
    return orElse();
  }
}

abstract class SubscriptionExpired implements ArticlesState {
  const factory SubscriptionExpired() = _$SubscriptionExpired;
}

/// @nodoc
abstract class $ContentCopyWith<$Res> {
  factory $ContentCopyWith(Content value, $Res Function(Content) then) =
      _$ContentCopyWithImpl<$Res>;
  $Res call({DataState<List<Article>, DataError> articles});

  $DataStateCopyWith<List<Article>, DataError, $Res> get articles;
}

/// @nodoc
class _$ContentCopyWithImpl<$Res> extends _$ArticlesStateCopyWithImpl<$Res>
    implements $ContentCopyWith<$Res> {
  _$ContentCopyWithImpl(Content _value, $Res Function(Content) _then)
      : super(_value, (v) => _then(v as Content));

  @override
  Content get _value => super._value as Content;

  @override
  $Res call({
    Object? articles = freezed,
  }) {
    return _then(Content(
      articles: articles == freezed
          ? _value.articles
          : articles // ignore: cast_nullable_to_non_nullable
              as DataState<List<Article>, DataError>,
    ));
  }

  @override
  $DataStateCopyWith<List<Article>, DataError, $Res> get articles {
    return $DataStateCopyWith<List<Article>, DataError, $Res>(_value.articles,
        (value) {
      return _then(_value.copyWith(articles: value));
    });
  }
}

/// @nodoc

class _$Content implements Content {
  const _$Content({required this.articles});

  @override
  final DataState<List<Article>, DataError> articles;

  @override
  String toString() {
    return 'ArticlesState.content(articles: $articles)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Content &&
            const DeepCollectionEquality().equals(other.articles, articles));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(articles));

  @JsonKey(ignore: true)
  @override
  $ContentCopyWith<Content> get copyWith =>
      _$ContentCopyWithImpl<Content>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() subscriptionExpired,
    required TResult Function(DataState<List<Article>, DataError> articles)
        content,
  }) {
    return content(articles);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? subscriptionExpired,
    TResult Function(DataState<List<Article>, DataError> articles)? content,
  }) {
    return content?.call(articles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? subscriptionExpired,
    TResult Function(DataState<List<Article>, DataError> articles)? content,
    required TResult orElse(),
  }) {
    if (content != null) {
      return content(articles);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SubscriptionExpired value) subscriptionExpired,
    required TResult Function(Content value) content,
  }) {
    return content(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SubscriptionExpired value)? subscriptionExpired,
    TResult Function(Content value)? content,
  }) {
    return content?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubscriptionExpired value)? subscriptionExpired,
    TResult Function(Content value)? content,
    required TResult orElse(),
  }) {
    if (content != null) {
      return content(this);
    }
    return orElse();
  }
}

abstract class Content implements ArticlesState {
  const factory Content(
      {required DataState<List<Article>, DataError> articles}) = _$Content;

  DataState<List<Article>, DataError> get articles;
  @JsonKey(ignore: true)
  $ContentCopyWith<Content> get copyWith => throw _privateConstructorUsedError;
}
