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
      String description,
      @JsonKey(name: "urlToImage") String imageUrl,
      String url,
      String publishedAt}) {
    return _ArticleApiModel(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      url: url,
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
  String get description;
  @JsonKey(name: "urlToImage")
  String get imageUrl;
  String get url;
  String get publishedAt;

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
      String description,
      @JsonKey(name: "urlToImage") String imageUrl,
      String url,
      String publishedAt});
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
    Object description = freezed,
    Object imageUrl = freezed,
    Object url = freezed,
    Object publishedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      title: title == freezed ? _value.title : title as String,
      description:
          description == freezed ? _value.description : description as String,
      imageUrl: imageUrl == freezed ? _value.imageUrl : imageUrl as String,
      url: url == freezed ? _value.url : url as String,
      publishedAt:
          publishedAt == freezed ? _value.publishedAt : publishedAt as String,
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
      String description,
      @JsonKey(name: "urlToImage") String imageUrl,
      String url,
      String publishedAt});
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
    Object description = freezed,
    Object imageUrl = freezed,
    Object url = freezed,
    Object publishedAt = freezed,
  }) {
    return _then(_ArticleApiModel(
      id: id == freezed ? _value.id : id as String,
      title: title == freezed ? _value.title : title as String,
      description:
          description == freezed ? _value.description : description as String,
      imageUrl: imageUrl == freezed ? _value.imageUrl : imageUrl as String,
      url: url == freezed ? _value.url : url as String,
      publishedAt:
          publishedAt == freezed ? _value.publishedAt : publishedAt as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
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
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(name: "urlToImage")
  final String imageUrl;
  @override
  final String url;
  @override
  final String publishedAt;

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
      String description,
      @JsonKey(name: "urlToImage") String imageUrl,
      String url,
      String publishedAt}) = _$_ArticleApiModel;

  factory _ArticleApiModel.fromJson(Map<String, dynamic> json) =
      _$_ArticleApiModel.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(name: "urlToImage")
  String get imageUrl;
  @override
  String get url;
  @override
  String get publishedAt;
  @override
  _$ArticleApiModelCopyWith<_ArticleApiModel> get copyWith;
}

ArticlesApiResponse _$ArticlesApiResponseFromJson(Map<String, dynamic> json) {
  return _ArticlesApiResponse.fromJson(json);
}

/// @nodoc
class _$ArticlesApiResponseTearOff {
  const _$ArticlesApiResponseTearOff();

// ignore: unused_element
  _ArticlesApiResponse call(
      {String status, int totalResults, List<ArticleApiModel> articles}) {
    return _ArticlesApiResponse(
      status: status,
      totalResults: totalResults,
      articles: articles,
    );
  }

// ignore: unused_element
  ArticlesApiResponse fromJson(Map<String, Object> json) {
    return ArticlesApiResponse.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $ArticlesApiResponse = _$ArticlesApiResponseTearOff();

/// @nodoc
mixin _$ArticlesApiResponse {
  String get status;
  int get totalResults;
  List<ArticleApiModel> get articles;

  Map<String, dynamic> toJson();
  $ArticlesApiResponseCopyWith<ArticlesApiResponse> get copyWith;
}

/// @nodoc
abstract class $ArticlesApiResponseCopyWith<$Res> {
  factory $ArticlesApiResponseCopyWith(
          ArticlesApiResponse value, $Res Function(ArticlesApiResponse) then) =
      _$ArticlesApiResponseCopyWithImpl<$Res>;
  $Res call({String status, int totalResults, List<ArticleApiModel> articles});
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
    Object status = freezed,
    Object totalResults = freezed,
    Object articles = freezed,
  }) {
    return _then(_value.copyWith(
      status: status == freezed ? _value.status : status as String,
      totalResults:
          totalResults == freezed ? _value.totalResults : totalResults as int,
      articles: articles == freezed
          ? _value.articles
          : articles as List<ArticleApiModel>,
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
  $Res call({String status, int totalResults, List<ArticleApiModel> articles});
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
    Object status = freezed,
    Object totalResults = freezed,
    Object articles = freezed,
  }) {
    return _then(_ArticlesApiResponse(
      status: status == freezed ? _value.status : status as String,
      totalResults:
          totalResults == freezed ? _value.totalResults : totalResults as int,
      articles: articles == freezed
          ? _value.articles
          : articles as List<ArticleApiModel>,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_ArticlesApiResponse
    with DiagnosticableTreeMixin
    implements _ArticlesApiResponse {
  const _$_ArticlesApiResponse({this.status, this.totalResults, this.articles});

  factory _$_ArticlesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$_$_ArticlesApiResponseFromJson(json);

  @override
  final String status;
  @override
  final int totalResults;
  @override
  final List<ArticleApiModel> articles;

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
      {String status,
      int totalResults,
      List<ArticleApiModel> articles}) = _$_ArticlesApiResponse;

  factory _ArticlesApiResponse.fromJson(Map<String, dynamic> json) =
      _$_ArticlesApiResponse.fromJson;

  @override
  String get status;
  @override
  int get totalResults;
  @override
  List<ArticleApiModel> get articles;
  @override
  _$ArticlesApiResponseCopyWith<_ArticlesApiResponse> get copyWith;
}
