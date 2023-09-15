import 'package:equatable/equatable.dart';

/// Represents an event that should be tracked by the analytics service
/// Review the [ANALYTICS](/docs/ANALYTICS.md) documentation for details
/// on how to create events and the limitations of the analytics service
class AnalyticsEvent extends Equatable {
  static const int _kMaxParameterValueLength = 100;

  final String name;
  final Map<String, dynamic>? parameters;

  const AnalyticsEvent._({
    required this.name,
    this.parameters,
  });

  @override
  List<Object?> get props => [
        name,
        parameters,
      ];

  static String _truncateParameterValue(String value) {
    if (value.length > _kMaxParameterValueLength) {
      return value.substring(0, _kMaxParameterValueLength);
    }
    return value;
  }

  factory AnalyticsEvent.appOpen() {
    return const AnalyticsEvent._(
      name: "app_open",
    );
  }

  factory AnalyticsEvent.login({required AnalyticsAuthMethod method}) {
    return AnalyticsEvent._(
      name: "login",
      parameters: {
        _ParameterKey.method.value: method.value,
      },
    );
  }

  factory AnalyticsEvent.signUp({required AnalyticsAuthMethod method}) {
    return AnalyticsEvent._(
      name: "sign_up",
      parameters: {
        _ParameterKey.method.value: method.value,
      },
    );
  }

  factory AnalyticsEvent.deleteAccount() {
    return const AnalyticsEvent._(
      name: "delete_account",
    );
  }

  factory AnalyticsEvent.logout() {
    return const AnalyticsEvent._(
      name: "logout",
    );
  }

  factory AnalyticsEvent.share({
    required AnalyticsContentType contentType,
    required int itemId,
  }) {
    return AnalyticsEvent._(
      name: "share",
      parameters: {
        _ParameterKey.contentType.value: contentType.value,
        _ParameterKey.itemId.value: itemId,
      },
    );
  }

  factory AnalyticsEvent.search({
    required String searchTerm,
  }) {
    return AnalyticsEvent._(
      name: "search",
      parameters: {
        _ParameterKey.searchTerm.value: _truncateParameterValue(searchTerm),
      },
    );
  }

  factory AnalyticsEvent.urlView({
    required String url,
  }) {
    return AnalyticsEvent._(
      name: "url_view",
      parameters: {
        _ParameterKey.url.value: _truncateParameterValue(url),
      },
    );
  }
}

enum _ParameterKey {
  method("method"),
  contentType("content_type"),
  itemId("item_id"),
  searchTerm("search_term"),
  url("url"),
  ;

  final String value;

  const _ParameterKey(this.value);
}

enum AnalyticsAuthMethod {
  facebook("facebook"),
  google("google"),
  apple("apple"),
  email("email"),
  ;

  final String value;

  const AnalyticsAuthMethod(this.value);
}

enum AnalyticsContentType {
  article("article"),
  ;

  final String value;

  const AnalyticsContentType(this.value);
}
