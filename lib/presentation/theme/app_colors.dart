import 'package:flutter/material.dart';

abstract class AppColors {
  // Background gradient
  static const Color backgroundDark = Color(0xFF1A0A2E);
  static const Color backgroundLight = Color(0xFF2D1B69);

  // Primary
  static const Color primary = Color(0xFFFFB74D); // sunrise gold
  static const Color secondary = Color(0xFFF48FB1); // soft pink
  static const Color accent = Color(0xFFCE93D8); // lavender

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% white
  static const Color textHint = Color(0x80FFFFFF); // 50% white

  // Cards
  static const Color cardBackground = Color(0x1AFFFFFF); // 10% white
  static const Color cardBorder = Color(0x33FFFFFF); // 20% white

  // Category colors
  static const Color selfLove = Color(0xFFE91E63);
  static const Color abundance = Color(0xFFFFD700);
  static const Color health = Color(0xFF4CAF50);
  static const Color relationships = Color(0xFFE91E63);
  static const Color career = Color(0xFF2196F3);
  static const Color confidence = Color(0xFFFF9800);
  static const Color peace = Color(0xFF9C27B0);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFB74D);

  // Misc
  static const Color divider = Color(0x1AFFFFFF);
  static const Color shimmer = Color(0x33FFFFFF);

  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [backgroundDark, backgroundLight],
      );

  static LinearGradient categoryGradient(Color color) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withValues(alpha: 0.8),
          color.withValues(alpha: 0.4),
        ],
      );
}
