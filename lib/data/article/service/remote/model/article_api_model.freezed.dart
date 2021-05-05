// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'article_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ArticleApiModel _$ArticleApiModelFromJson(Map<String, dynamic> json) {
  return _ArticleApiModel.fromJson(json);
}

/// @nodoc
class _$ArticleApiModelTearOff {
  const _$ArticleApiModelTearOff();

  _ArticleApiModel call(
      {String? id,
      String? title,
      String? description,
      @JsonKey(name: "urlToImage") String? imageUrl,
      String? url,
      String? publishedAt}) {
    return _ArticleApiModel(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      url: url,
      publishedAt: publishedAt,
    );
  }

  ArticleApiModel fromJson(Map<String, Object> json) {
    return ArticleApiModel.fromJson(json);
  }
}

/// @nodoc
const $ArticleApiModel = _$ArticleApiModelTearOff();

/// @nodoc
mixin _$ArticleApiModel {
  String? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: "urlToImage")
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get publishedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArticleApiModelCopyWith<ArticleApiModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleApiModelCopyWith<$Res> {
  factory $ArticleApiModelCopyWith(
          ArticleApiModel value, $Res Function(ArticleApiModel) then) =
      _$ArticleApiModelCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      String? title,
      String? description,
      @JsonKey(name: "urlToImage") String? imageUrl,
      String? url,
      String? publishedAt});
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
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? url = freezed,
    Object? publishedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      publishedAt: publishedAt == freezed
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String? id,
      String? title,
      String? description,
      @JsonKey(name: "urlToImage") String? imageUrl,
      String? url,
      String? publishedAt});
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
    Object? id = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? url = freezed,
    Object? publishedAt = freezed,
  }) {
    return _then(_ArticleApiModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      publishedAt: publishedAt == freezed
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ArticleApiModel extends _ArticleApiModel with DiagnosticableTreeMixin {
  const _$_ArticleApiModel(
      {this.id,
      this.title,
      this.description,
      @JsonKey(name: "urlToImage") this.imageUrl,
      this.url,
      this.publishedAt})
      : super._();

  factory _$_ArticleApiModel.fromJson(Map<String, dynamic> json) =>
      _$_$_ArticleApiModelFromJson(json);

  @override
  final String? id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey(name: "urlToImage")
  final String? imageUrl;
  @override
  final String? url;
  @override
  final String? publishedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ArticleApiModel(id: $id, title: $title, description: $description, imageUrl: $imageUrl, url: $url, publishedAt: $publishedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ArticleApiModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('imageUrl', imageUrl))
      ..add(DiagnosticsProperty('url', url))
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
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.imageUrl, imageUrl) ||
                const DeepCollectionEquality()
                    .equals(other.imageUrl, imageUrl)) &&
            (identical(other.url, url) ||
                const DeepCollectionEquality().equals(other.url, url)) &&
            (identical(other.publishedAt, publishedAt) ||
                const DeepCollectionEquality()
                    .equals(other.publishedAt, publishedAt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(imageUrl) ^
      const DeepCollectionEquality().hash(url) ^
      const DeepCollectionEquality().hash(publishedAt);

  @JsonKey(ignore: true)
  @override
  _$ArticleApiModelCopyWith<_ArticleApiModel> get copyWith =>
      __$ArticleApiModelCopyWithImpl<_ArticleApiModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ArticleApiModelToJson(this);
  }
}

abstract class _ArticleApiModel extends ArticleApiModel {
  const factory _ArticleApiModel(
      {String? id,
      String? title,
      String? description,
      @JsonKey(name: "urlToImage") String? imageUrl,
      String? url,
      String? publishedAt}) = _$_ArticleApiModel;
  const _ArticleApiModel._() : super._();

  factory _ArticleApiModel.fromJson(Map<String, dynamic> json) =
      _$_ArticleApiModel.fromJson;

  @override
  String? get id => throw _privateConstructorUsedError;
  @override
  String? get title => throw _privateConstructorUsedError;
  @override
  String? get description => throw _privateConstructorUsedError;
  @override
  @JsonKey(name: "urlToImage")
  String? get imageUrl => throw _privateConstructorUsedError;
  @override
  String? get url => throw _privateConstructorUsedError;
  @override
  String? get publishedAt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ArticleApiModelCopyWith<_ArticleApiModel> get copyWith =>
      throw _privateConstructorUsedError;
}

ArticlesApiResponse _$ArticlesApiResponseFromJson(Map<String, dynamic> json) {
  return _ArticlesApiResponse.fromJson(json);
}

/// @nodoc
class _$ArticlesApiResponseTearOff {
  const _$ArticlesApiResponseTearOff();

  _ArticlesApiResponse call(
      {String? status, int? totalResults, List<ArticleApiModel>? articles}) {
    return _ArticlesApiResponse(
      status: status,
      totalResults: totalResults,
      articles: articles,
    );
  }

  ArticlesApiResponse fromJson(Map<String, Object> json) {
    return ArticlesApiResponse.fromJson(json);
  }
}

/// @nodoc
const $ArticlesApiResponse = _$ArticlesApiResponseTearOff();

/// @nodoc
mixin _$ArticlesApiResponse {
  String? get status => throw _privateConstructorUsedError;
  int? get totalResults => throw _privateConstructorUsedError;
  List<ArticleApiModel>? get articles => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArticlesApiResponseCopyWith<ArticlesApiResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticlesApiResponseCopyWith<$Res> {
  factory $ArticlesApiResponseCopyWith(
          ArticlesApiResponse value, $Res Function(ArticlesApiResponse) then) =
      _$ArticlesApiResponseCopyWithImpl<$Res>;
  $Res call(
      {String? status, int? totalResults, List<ArticleApiModel>? articles});
}

/// @nodoc
class _$ArticlesApiResponseCopyWithImpl<$Res>
    implements $ArticlesApiResponseCopyWith<$Res> {
  _$ArticlesApiResponseCopyWithImpl(this._value, this._then);

  final ArticlesApiResponse _value;
  // ignore: unused_field
  final $Res Function(ArticlesApiResponse) _then;

  @override
  $Res call({
    Object? status = freezed,
    Object? totalResults = freezed,
    Object? articles = freezed,
  }) {
    return _then(_value.copyWith(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      totalResults: totalResults == freezed
          ? _value.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int?,
      articles: articles == freezed
          ? _value.articles
          : articles // ignore: cast_nullable_to_non_nullable
              as List<ArticleApiModel>?,
    ));
  }
}

/// @nodoc
abstract class _$ArticlesApiResponseCopyWith<$Res>
    implements $ArticlesApiResponseCopyWith<$Res> {
  factory _$ArticlesApiResponseCopyWith(_ArticlesApiResponse value,
          $Res Function(_ArticlesApiResponse) then) =
      __$ArticlesApiResponseCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? status, int? totalResults, List<ArticleApiModel>? articles});
}

/// @nodoc
class __$ArticlesApiResponseCopyWithImpl<$Res>
    extends _$ArticlesApiResponseCopyWithImpl<$Res>
    implements _$ArticlesApiResponseCopyWith<$Res> {
  __$ArticlesApiResponseCopyWithImpl(
      _ArticlesApiResponse _value, $Res Function(_ArticlesApiResponse) _then)
      : super(_value, (v) => _then(v as _ArticlesApiResponse));

  @override
  _ArticlesApiResponse get _value => super._value as _ArticlesApiResponse;

  @override
  $Res call({
    Object? status = freezed,
    Object? totalResults = freezed,
    Object? articles = freezed,
  }) {
    return _then(_ArticlesApiResponse(
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      totalResults: totalResults == freezed
          ? _value.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int?,
      articles: articles == freezed
          ? _value.articles
          : articles // ignore: cast_nullable_to_non_nullable
              as List<ArticleApiModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ArticlesApiResponse
    with DiagnosticableTreeMixin
    implements _ArticlesApiResponse {
  const _$_ArticlesApiResponse({this.status, this.totalResults, this.articles});

  factory _$_ArticlesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$_$_ArticlesApiResponseFromJson(json);

  @override
  final String? status;
  @override
  final int? totalResults;
  @override
  final List<ArticleApiModel>? articles;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ArticlesApiResponse(status: $status, totalResults: $totalResults, articles: $articles)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ArticlesApiResponse'))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('totalResults', totalResults))
      ..add(DiagnosticsProperty('articles', articles));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ArticlesApiResponse &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.totalResults, totalResults) ||
                const DeepCollectionEquality()
                    .equals(other.totalResults, totalResults)) &&
            (identical(other.articles, articles) ||
                const DeepCollectionEquality()
                    .equals(other.articles, articles)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(totalResults) ^
      const DeepCollectionEquality().hash(articles);

  @JsonKey(ignore: true)
  @override
  _$ArticlesApiResponseCopyWith<_ArticlesApiResponse> get copyWith =>
      __$ArticlesApiResponseCopyWithImpl<_ArticlesApiResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ArticlesApiResponseToJson(this);
  }
}

abstract class _ArticlesApiResponse implements ArticlesApiResponse {
  const factory _ArticlesApiResponse(
      {String? status,
      int? totalResults,
      List<ArticleApiModel>? articles}) = _$_ArticlesApiResponse;

  factory _ArticlesApiResponse.fromJson(Map<String, dynamic> json) =
      _$_ArticlesApiResponse.fromJson;

  @override
  String? get status => throw _privateConstructorUsedError;
  @override
  int? get totalResults => throw _privateConstructorUsedError;
  @override
  List<ArticleApiModel>? get articles => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ArticlesApiResponseCopyWith<_ArticlesApiResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
