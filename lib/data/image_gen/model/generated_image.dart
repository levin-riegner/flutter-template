import 'package:equatable/equatable.dart';

/// A generated image plus the prompt that produced it.
class GeneratedImage extends Equatable {
  final String id;
  final String prompt;
  final String? url;
  final String? localPath;

  const GeneratedImage({
    required this.id,
    required this.prompt,
    this.url,
    this.localPath,
  });

  @override
  List<Object?> get props => [id, prompt, url, localPath];
}
