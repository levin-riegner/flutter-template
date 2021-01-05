// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'articles_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ArticlesStateTearOff {
  const _$ArticlesStateTearOff();

// ignore: unused_element
  SubscriptionExpired subscriptionExpired() {
    return const SubscriptionExpired();
  }

// ignore: unused_element
  Content content(
      {@required DataState<List<Article>, ArticlesError> articles}) {
    return Content(
      articles: articles,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $ArticlesState = _$ArticlesStateTearOff();

/// @nodoc
mixin _$ArticlesState {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult subscriptionExpired(),
    @required TResult content(DataState<List<Article>, ArticlesError> articles),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult subscriptionExpired(),
    TResult content(DataState<List<Article>, ArticlesError> articles),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult subscriptionExpired(SubscriptionExpired value),
    @required TResult content(Content value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult subscriptionExpired(SubscriptionExpired value),
    TResult content(Content value),
    @required TResult orElse(),
  });
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
class _$SubscriptionExpired
    with DiagnosticableTreeMixin
    implements SubscriptionExpired {
  const _$SubscriptionExpired();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ArticlesState.subscriptionExpired()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ArticlesState.subscriptionExpired'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is SubscriptionExpired);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult subscriptionExpired(),
    @required TResult content(DataState<List<Article>, ArticlesError> articles),
  }) {
    assert(subscriptionExpired != null);
    assert(content != null);
    return subscriptionExpired();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult subscriptionExpired(),
    TResult content(DataState<List<Article>, ArticlesError> articles),
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
    @required TResult subscriptionExpired(SubscriptionExpired value),
    @required TResult content(Content value),
  }) {
    assert(subscriptionExpired != null);
    assert(content != null);
    return subscriptionExpired(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult subscriptionExpired(SubscriptionExpired value),
    TResult content(Content value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
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
  $Res call({DataState<List<Article>, ArticlesError> articles});

  $DataStateCopyWith<List<Article>, ArticlesError, $Res> get articles;
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
    Object articles = freezed,
  }) {
    return _then(Content(
      articles: articles == freezed
          ? _value.articles
          : articles as DataState<List<Article>, ArticlesError>,
    ));
  }

  @override
  $DataStateCopyWith<List<Article>, ArticlesError, $Res> get articles {
    if (_value.articles == null) {
      return null;
    }
    return $DataStateCopyWith<List<Article>, ArticlesError, $Res>(
        _value.articles, (value) {
      return _then(_value.copyWith(articles: value));
    });
  }
}

/// @nodoc
class _$Content with DiagnosticableTreeMixin implements Content {
  const _$Content({@required this.articles}) : assert(articles != null);

  @override
  final DataState<List<Article>, ArticlesError> articles;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ArticlesState.content(articles: $articles)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ArticlesState.content'))
      ..add(DiagnosticsProperty('articles', articles));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Content &&
            (identical(other.articles, articles) ||
                const DeepCollectionEquality()
                    .equals(other.articles, articles)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(articles);

  @override
  $ContentCopyWith<Content> get copyWith =>
      _$ContentCopyWithImpl<Content>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult subscriptionExpired(),
    @required TResult content(DataState<List<Article>, ArticlesError> articles),
  }) {
    assert(subscriptionExpired != null);
    assert(content != null);
    return content(articles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult subscriptionExpired(),
    TResult content(DataState<List<Article>, ArticlesError> articles),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (content != null) {
      return content(articles);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult subscriptionExpired(SubscriptionExpired value),
    @required TResult content(Content value),
  }) {
    assert(subscriptionExpired != null);
    assert(content != null);
    return content(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult subscriptionExpired(SubscriptionExpired value),
    TResult content(Content value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (content != null) {
      return content(this);
    }
    return orElse();
  }
}

abstract class Content implements ArticlesState {
  const factory Content(
      {@required DataState<List<Article>, ArticlesError> articles}) = _$Content;

  DataState<List<Article>, ArticlesError> get articles;
  $ContentCopyWith<Content> get copyWith;
}
