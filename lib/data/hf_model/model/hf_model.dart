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
  // Licensing: HuggingFace model licences vary. Some (Mistral, Llama 2, Gemma,
  // and many CC-BY-NC models) are non-commercial or restrict commercial use;
  // others (Apache-2.0, MIT, Llama 3.x Community, DeepSeek, Phi, GPT-OSS, Qwen
  // under Apache) are commercial-friendly. We only surface models we can ship
  // in a paid app, so the check is FAIL-CLOSED: unless we can positively prove a
  // model is commercial-safe, it is excluded.
  //
  // The check is a double gate:
  //   1. Licence-field classification (see [_permissiveLicenses]/_
  //      [_restrictedLicenses]).
  //   2. Cross-check against a curated commercial family allow-list, used only
  //      as a fallback when the licence field is absent or unrecognised.
  // ---------------------------------------------------------------------------

  /// Licences that unambiguously permit commercial use.
  static const Set<String> _permissiveLicenses = {
    'apache-2.0', 'apache 2.0', 'apache2', 'mit', 'bsd', 'bsd-3-clause',
    'bsd-2-clause', 'llama3.1', 'llama3.2', 'llama3.3', 'llama-3.1',
    'llama-3.2', 'llama-3.3', 'llama 3.1', 'llama 3.2', 'llama 3.3',
    'deepseek', 'deepseek license', 'phi', 'phi-license', 'phi-2', 'phi-3',
    'openai', 'openai model license', 'gpt-oss', 'olmo', 'olmo license',
    'aya', 'aya license', 'command-r', 'command-r license', 'glm', 'glm license',
    'mistral-large-123b', 'qwen license', 'qwen', 'gemma2', 'gemma-2',
    'gemma 2', 'gemma terms of use', 'styles license', 'smollm license',
    'tinyllama', 't-notice', 'other maas',
  };

  /// Licences that explicitly forbid or restrict commercial use (never pass).
  static const Set<String> _restrictedLicenses = {
    'cc-by-nc-4.0', 'cc-by-nc', 'cc-by-nc-sa-4.0', 'cc-by-nc-nd-4.0',
    'non-commercial', 'noncommercial', 'llama2', 'llama-2', 'llama 2',
    'meta llama 2', 'mistral', 'mistral license', 'gemma (non-commercial)',
    'gemma nvidia', 'nvidia ai foundation', 'ai2 llm agreement', 'cc-by-sa',
    'falcon', 'falcon license', 'bigscience noncommercial', 'nic',
  };

  /// Commercial-friendly model *families* used as the cross-check fallback when
  /// the licence field is absent or unrecognised (fail-closed otherwise).
  static const Set<String> _commercialFamilies = {
    'llama-3.1', 'llama-3.2', 'llama-3.3', 'llama3.1', 'llama3.2', 'llama3.3',
    'deepseek', 'qwen2', 'qwen2.5', 'phi-3', 'phi-4', 'gpt-oss', 'olmo',
    'aya', 'command-r', 'glm-4', 'gemma-2', 'smol', 'ministral', 'crystal',
  };

  static String _normalize(String? value) {
    return (value ?? '').toLowerCase().replaceAll('_', '-').trim();
  }

  /// True when this model's licence is positively compatible with commercial
  /// distribution. Fail-closed: an unknown or missing licence does NOT pass
  /// unless the repo-id family is known commercial.
  bool get isCommercialSafe {
    final licenseToken = _normalize(license);

    // GATE 1: explicit restricted licence => never allowed.
    if (_restrictedLicenses.any(licenseToken.contains)) {
      return false;
    }

    // GATE 2: explicit permissive licence => allowed.
    if (licenseToken.isNotEmpty &&
        _permissiveLicenses.any(licenseToken.contains)) {
      return true;
    }

    // CROSS-CHECK (fallback): licence absent/unrecognised. Only a curated
    // commercial family allow-list passes; everything else fails closed.
    final idToken = id.toLowerCase();
    return _commercialFamilies.any((family) => idToken.contains(family));
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
