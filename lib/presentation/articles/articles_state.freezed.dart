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
  ConfirmRegistration confirmRegistration() {
    return const ConfirmRegistration();
  }

// ignore: unused_element
  Content content({@required DataState<List<Article>, dynamic> articles}) {
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
    @required TResult confirmRegistration(),
    @required TResult content(DataState<List<Article>, dynamic> articles),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult confirmRegistration(),
    TResult content(DataState<List<Article>, dynamic> articles),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult confirmRegistration(ConfirmRegistration value),
    @required TResult content(Content value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult confirmRegistration(ConfirmRegistration value),
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
abstract class $ConfirmRegistrationCopyWith<$Res> {
  factory $ConfirmRegistrationCopyWith(
          ConfirmRegistration value, $Res Function(ConfirmRegistration) then) =
      _$ConfirmRegistrationCopyWithImpl<$Res>;
}

/// @nodoc
class _$ConfirmRegistrationCopyWithImpl<$Res>
    extends _$ArticlesStateCopyWithImpl<$Res>
    implements $ConfirmRegistrationCopyWith<$Res> {
  _$ConfirmRegistrationCopyWithImpl(
      ConfirmRegistration _value, $Res Function(ConfirmRegistration) _then)
      : super(_value, (v) => _then(v as ConfirmRegistration));

  @override
  ConfirmRegistration get _value => super._value as ConfirmRegistration;
}

/// @nodoc
class _$ConfirmRegistration
    with DiagnosticableTreeMixin
    implements ConfirmRegistration {
  const _$ConfirmRegistration();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ArticlesState.confirmRegistration()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ArticlesState.confirmRegistration'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is ConfirmRegistration);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult confirmRegistration(),
    @required TResult content(DataState<List<Article>, dynamic> articles),
  }) {
    assert(confirmRegistration != null);
    assert(content != null);
    return confirmRegistration();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult confirmRegistration(),
    TResult content(DataState<List<Article>, dynamic> articles),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (confirmRegistration != null) {
      return confirmRegistration();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult confirmRegistration(ConfirmRegistration value),
    @required TResult content(Content value),
  }) {
    assert(confirmRegistration != null);
    assert(content != null);
    return confirmRegistration(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult confirmRegistration(ConfirmRegistration value),
    TResult content(Content value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (confirmRegistration != null) {
      return confirmRegistration(this);
    }
    return orElse();
  }
}

abstract class ConfirmRegistration implements ArticlesState {
  const factory ConfirmRegistration() = _$ConfirmRegistration;
}

/// @nodoc
abstract class $ContentCopyWith<$Res> {
  factory $ContentCopyWith(Content value, $Res Function(Content) then) =
      _$ContentCopyWithImpl<$Res>;
  $Res call({DataState<List<Article>, dynamic> articles});

  $DataStateCopyWith<List<Article>, dynamic, $Res> get articles;
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
          : articles as DataState<List<Article>, dynamic>,
    ));
  }

  @override
  $DataStateCopyWith<List<Article>, dynamic, $Res> get articles {
    if (_value.articles == null) {
      return null;
    }
    return $DataStateCopyWith<List<Article>, dynamic, $Res>(_value.articles,
        (value) {
      return _then(_value.copyWith(articles: value));
    });
  }
}

/// @nodoc
class _$Content with DiagnosticableTreeMixin implements Content {
  const _$Content({@required this.articles}) : assert(articles != null);

  @override
  final DataState<List<Article>, dynamic> articles;

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
    @required TResult confirmRegistration(),
    @required TResult content(DataState<List<Article>, dynamic> articles),
  }) {
    assert(confirmRegistration != null);
    assert(content != null);
    return content(articles);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult confirmRegistration(),
    TResult content(DataState<List<Article>, dynamic> articles),
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
    @required TResult confirmRegistration(ConfirmRegistration value),
    @required TResult content(Content value),
  }) {
    assert(confirmRegistration != null);
    assert(content != null);
    return content(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult confirmRegistration(ConfirmRegistration value),
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
      {@required DataState<List<Article>, dynamic> articles}) = _$Content;

  DataState<List<Article>, dynamic> get articles;
  $ContentCopyWith<Content> get copyWith;
}
