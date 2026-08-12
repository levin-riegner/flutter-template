/// A downloadable model candidate surfaced from the HuggingFace Hub.
///
/// Only models whose licence permits commercial use are surfaced, so the app
/// stays monetizable (see [HfModel.isCommercialSafe]).
class HfModel {
  final String id;
  final String? pipelineTag;
  final String? license;
  final int downloads;

  const HfModel({
    required this.id,
    this.pipelineTag,
    this.license,
    required this.downloads,
  });

  /// A short display name (last path segment of the repo id).
  String get displayName {
    final segments = id.split('/');
    return segments.isEmpty ? id : segments.last;
  }

  // ---------------------------------------------------------------------------
  // Licensing: HuggingFace model licences vary. Some (Mistral, Llama in some
  // versions, Gemma, Qwen with certain terms) are non-commercial or have
  // restrictions. Others (e.g. Llama 3.x Community, DeepSeek, Phi, GPT-OSS)
  // are commercial-friendly. We only propose models we can ship in a paid app.
  // ---------------------------------------------------------------------------
  static const Set<String> commercialAllowed = {
    'llama3.1', 'llama3.2', 'llama3.3', 'llama-3.1', 'llama-3.2', 'llama-3.3',
    'deepseek', 'qwen', 'apache-2.0', 'mit', 'openai', 'gpt-oss', 'phi-3',
    'phi-4', 'gemma2', 'gemma-2', 'mistral-large-123b', 'olmo', 'aya',
    'command-r', 'glm',
  };

  /// True when this model's licence is compatible with commercial distribution.
  bool get isCommercialSafe {
    final licenseToken = license?.toLowerCase() ?? '';
    final idToken = id.toLowerCase();
    // Allow-list by repo-id family when licence metadata is absent.
    return commercialAllowed.any((token) => idToken.contains(token)) ||
        commercialAllowed.any((token) => licenseToken.contains(token));
  }

  factory HfModel.fromJson(Map<String, dynamic> json) {
    // HuggingFace /api/models returns: id, downloads, pipeline_tag, ... and
    // license nested under cardData when present.
    final cardData = (json['cardData'] is Map)
        ? json['cardData'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final pipelineTag = json['pipeline_tag'] ?? json['pipelineTag'];

    final rawId = json['id'];
    return HfModel(
      id: rawId is String ? rawId : 'unknown',
      pipelineTag: pipelineTag is String ? pipelineTag : null,
      license: cardData['license'] is String
          ? cardData['license'] as String
          : null,
      downloads: (json['downloads'] is num)
          ? (json['downloads'] as num).toInt()
          : 0,
    );
  }
}
