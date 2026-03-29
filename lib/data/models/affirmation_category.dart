enum AffirmationCategory {
  selfLove,
  abundance,
  health,
  relationships,
  career,
  confidence,
  peace;

  String get displayName {
    switch (this) {
      case AffirmationCategory.selfLove:
        return 'Self Love';
      case AffirmationCategory.abundance:
        return 'Abundance';
      case AffirmationCategory.health:
        return 'Health';
      case AffirmationCategory.relationships:
        return 'Relationships';
      case AffirmationCategory.career:
        return 'Career';
      case AffirmationCategory.confidence:
        return 'Confidence';
      case AffirmationCategory.peace:
        return 'Peace';
    }
  }

  String get icon {
    switch (this) {
      case AffirmationCategory.selfLove:
        return '💖';
      case AffirmationCategory.abundance:
        return '✨';
      case AffirmationCategory.health:
        return '🌿';
      case AffirmationCategory.relationships:
        return '💞';
      case AffirmationCategory.career:
        return '🚀';
      case AffirmationCategory.confidence:
        return '🔥';
      case AffirmationCategory.peace:
        return '🕊️';
    }
  }

  int get colorValue {
    switch (this) {
      case AffirmationCategory.selfLove:
        return 0xFFE91E63;
      case AffirmationCategory.abundance:
        return 0xFFFFD700;
      case AffirmationCategory.health:
        return 0xFF4CAF50;
      case AffirmationCategory.relationships:
        return 0xFFE91E63;
      case AffirmationCategory.career:
        return 0xFF2196F3;
      case AffirmationCategory.confidence:
        return 0xFFFF9800;
      case AffirmationCategory.peace:
        return 0xFF9C27B0;
    }
  }
}
