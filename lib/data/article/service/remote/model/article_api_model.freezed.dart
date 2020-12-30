// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'article_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ArticleApiModel _$ArticleApiModelFromJson(Map<String, dynamic> json) {
  return _ArticleApiModel.fromJson(json);
}

/// @nodoc
class _$ArticleApiModelTearOff {
  const _$ArticleApiModelTearOff();

// ignore: unused_element
  _ArticleApiModel call(
      {String id,
      String title,
      String url,
      @JsonKey(name: "read_time") int readTimeInSeconds,
      int publishedAt}) {
    return _ArticleApiModel(
      id: id,
      title: title,
      url: url,
      readTimeInSeconds: readTimeInSeconds,
      publishedAt: publishedAt,
    );
  }

// ignore: unused_element
  ArticleApiModel fromJson(Map<String, Object> json) {
    return ArticleApiModel.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ArticleApiModel = _$ArticleApiModelTearOff();

/// @nodoc
mixin _$ArticleApiModel {
  String get id;
  String get title;
  String get url;
  @JsonKey(name: "read_time")
  int get readTimeInSeconds;
  int get publishedAt;

  Map<String, dynamic> toJson();
  $ArticleApiModelCopyWith<ArticleApiModel> get copyWith;
}

/// @nodoc
abstract class $ArticleApiModelCopyWith<$Res> {
  factory $ArticleApiModelCopyWith(
          ArticleApiModel value, $Res Function(ArticleApiModel) then) =
      _$ArticleApiModelCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String title,
      String url,
      @JsonKey(name: "read_time") int readTimeInSeconds,
      int publishedAt});
}

/// @nodoc
class _$ArticleApiModelCopyWithImpl<$Res>
    implements $ArticleApiModelCopyWith<$Res> {
  _$ArticleApiModelCopyWithImpl(this._value, this._then);

  final ArticleApiModel _value;
  // ignore: unused_field
  final $Res Function(ArticleApiModel) _then;

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
          publishedAt == freezed ? _value.publishedAt : publishedAt as int,
    ));
  }
}

/// @nodoc
abstract class _$ArticleApiModelCopyWith<$Res>
    implements $ArticleApiModelCopyWith<$Res> {
  factory _$ArticleApiModelCopyWith(
          _ArticleApiModel value, $Res Function(_ArticleApiModel) then) =
      __$ArticleApiModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String title,
      String url,
      @JsonKey(name: "read_time") int readTimeInSeconds,
      int publishedAt});
}

/// @nodoc
class __$ArticleApiModelCopyWithImpl<$Res>
    extends _$ArticleApiModelCopyWithImpl<$Res>
    implements _$ArticleApiModelCopyWith<$Res> {
  __$ArticleApiModelCopyWithImpl(
      _ArticleApiModel _value, $Res Function(_ArticleApiModel) _then)
      : super(_value, (v) => _then(v as _ArticleApiModel));

  @override
  _ArticleApiModel get _value => super._value as _ArticleApiModel;

  @override
  $Res call({
    Object id = freezed,
    Object title = freezed,
    Object url = freezed,
    Object readTimeInSeconds = freezed,
    Object publishedAt = freezed,
  }) {
    return _then(_ArticleApiModel(
      id: id == freezed ? _value.id : id as String,
      title: title == freezed ? _value.title : title as String,
      url: url == freezed ? _value.url : url as String,
      readTimeInSeconds: readTimeInSeconds == freezed
          ? _value.readTimeInSeconds
          : readTimeInSeconds as int,
      publishedAt:
          publishedAt == freezed ? _value.publishedAt : publishedAt as int,
    ));
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)

/// @nodoc
class _$_ArticleApiModel extends _ArticleApiModel with DiagnosticableTreeMixin {
  const _$_ArticleApiModel(
      {this.id,
      this.title,
      this.url,
      @JsonKey(name: "read_time") this.readTimeInSeconds,
      this.publishedAt})
      : super._();

  factory _$_ArticleApiModel.fromJson(Map<String, dynamic> json) =>
      _$_$_ArticleApiModelFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String url;
  @override
  @JsonKey(name: "read_time")
  final int readTimeInSeconds;
  @override
  final int publishedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ArticleApiModel(id: $id, title: $title, url: $url, readTimeInSeconds: $readTimeInSeconds, publishedAt: $publishedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ArticleApiModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('url', url))
      ..add(DiagnosticsProperty('readTimeInSeconds', readTimeInSeconds))
      ..add(DiagnosticsProperty('publishedAt', publishedAt));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ArticleApiModel &&
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
  _$ArticleApiModelCopyWith<_ArticleApiModel> get copyWith =>
      __$ArticleApiModelCopyWithImpl<_ArticleApiModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ArticleApiModelToJson(this);
  }
}

abstract class _ArticleApiModel extends ArticleApiModel {
  const _ArticleApiModel._() : super._();
  const factory _ArticleApiModel(
      {String id,
      String title,
      String url,
      @JsonKey(name: "read_time") int readTimeInSeconds,
      int publishedAt}) = _$_ArticleApiModel;

  factory _ArticleApiModel.fromJson(Map<String, dynamic> json) =
      _$_ArticleApiModel.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get url;
  @override
  @JsonKey(name: "read_time")
  int get readTimeInSeconds;
  @override
  int get publishedAt;
  @override
  _$ArticleApiModelCopyWith<_ArticleApiModel> get copyWith;
}
