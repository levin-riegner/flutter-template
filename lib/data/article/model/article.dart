import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? url;
  final DateTime? publishedAt;

  const Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
    required this.publishedAt,
  });

  @override
  List<Object?> get props =>
      [id, title, description, imageUrl, url, publishedAt];
}
