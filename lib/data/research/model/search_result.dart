import 'package:equatable/equatable.dart';

/// One web-search hit.
class SearchResult extends Equatable {
  final String title;
  final String url;
  final String snippet;

  const SearchResult({
    required this.title,
    required this.url,
    required this.snippet,
  });

  @override
  List<Object?> get props => [title, url, snippet];
}
