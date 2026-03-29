import 'package:flutter/material.dart';
import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class AffirmationCard extends StatelessWidget {
  final Affirmation affirmation;

  const AffirmationCard({super.key, required this.affirmation});

  @override
  Widget build(BuildContext context) {
    final color = Color(affirmation.category.colorValue);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.3),
            color.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(affirmation.category.icon,
                  style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                affirmation.category.displayName,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            affirmation.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap to explore more →',
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
