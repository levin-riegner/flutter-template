// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'article.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ArticleTearOff {
  const _$ArticleTearOff();

// ignore: unused_element
  _Article call(
      {String id,
      String title,
      String url,
      int readTimeInSeconds,
      DateTime publishedAt}) {
    return _Article(
      id: id,
      title: title,
      url: url,
      readTimeInSeconds: readTimeInSeconds,
      publishedAt: publishedAt,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $Article = _$ArticleTearOff();

/// @nodoc
mixin _$Article {
  String get id;
  String get title;
  String get url;
  int get readTimeInSeconds;
  DateTime get publishedAt;

  $ArticleCopyWith<Article> get copyWith;
}

/// @nodoc
abstract class $ArticleCopyWith<$Res> {
  factory $ArticleCopyWith(Article value, $Res Function(Article) then) =
      _$ArticleCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String title,
      String url,
      int readTimeInSeconds,
      DateTime publishedAt});
}

/// @nodoc
class _$ArticleCopyWithImpl<$Res> implements $ArticleCopyWith<$Res> {
  _$ArticleCopyWithImpl(this._value, this._then);

  final Article _value;
  // ignore: unused_field
  final $Res Function(Article) _then;

  @override
  $Res call({
    Object id = freezed,
    Object title = freezed,
    Object url = freezed,
    Object readTimeInSeconds = freezed,
    Object publishedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      title: title == freezed ? _value.title : title as String,
      url: url == freezed ? _value.url : url as String,
      readTimeInSeconds: readTimeInSeconds == freezed
          ? _value.readTimeInSeconds
          : readTimeInSeconds as int,
      publishedAt:
          publishedAt == freezed ? _value.publishedAt : publishedAt as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$ArticleCopyWith<$Res> implements $ArticleCopyWith<$Res> {
  factory _$ArticleCopyWith(_Article value, $Res Function(_Article) then) =
      __$ArticleCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String title,
      String url,
      int readTimeInSeconds,
      DateTime publishedAt});
}

/// @nodoc
class __$ArticleCopyWithImpl<$Res> extends _$ArticleCopyWithImpl<$Res>
    implements _$ArticleCopyWith<$Res> {
  __$ArticleCopyWithImpl(_Article _value, $Res Function(_Article) _then)
      : super(_value, (v) => _then(v as _Article));

  @override
  _Article get _value => super._value as _Article;

  @override
  $Res call({
    Object id = freezed,
    Object title = freezed,
    Object url = freezed,
    Object readTimeInSeconds = freezed,
    Object publishedAt = freezed,
  }) {
    return _then(_Article(
      id: id == freezed ? _value.id : id as String,
      title: title == freezed ? _value.title : title as String,
      url: url == freezed ? _value.url : url as String,
      readTimeInSeconds: readTimeInSeconds == freezed
          ? _value.readTimeInSeconds
          : readTimeInSeconds as int,
      publishedAt:
          publishedAt == freezed ? _value.publishedAt : publishedAt as DateTime,
    ));
  }
}

/// @nodoc
class _$_Article extends _Article with DiagnosticableTreeMixin {
  const _$_Article(
      {this.id, this.title, this.url, this.readTimeInSeconds, this.publishedAt})
      : super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final String url;
  @override
  final int readTimeInSeconds;
  @override
  final DateTime publishedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Article(id: $id, title: $title, url: $url, readTimeInSeconds: $readTimeInSeconds, publishedAt: $publishedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Article'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('url', url))
      ..add(DiagnosticsProperty('readTimeInSeconds', readTimeInSeconds))
      ..add(DiagnosticsProperty('publishedAt', publishedAt));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Article &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.readTimeInSeconds, readTimeInSeconds) ||
                const DeepCollectionEquality()
                    .equals(other.readTimeInSeconds, readTimeInSeconds)) &&
            (identical(other.publishedAt, publishedAt) ||
                const DeepCollectionEquality()
                    .equals(other.publishedAt, publishedAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(readTimeInSeconds) ^
      const DeepCollectionEquality().hash(publishedAt);

  @override
  _$ArticleCopyWith<_Article> get copyWith =>
      __$ArticleCopyWithImpl<_Article>(this, _$identity);
}

abstract class _Article extends Article {
  const _Article._() : super._();
  const factory _Article(
      {String id,
      String title,
      String url,
      int readTimeInSeconds,
      DateTime publishedAt}) = _$_Article;

  @override
  String get id;
  @override
  String get title;
  @override
  String get url;
  @override
  int get readTimeInSeconds;
  @override
  DateTime get publishedAt;
  @override
  _$ArticleCopyWith<_Article> get copyWith;
}
