import 'package:flutter/material.dart';
import 'package:affirmup/data/models/affirmation_category.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final AffirmationCategory category;
  final bool isLocked;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isLocked
              ? AppColors.cardBackground
              : color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLocked
                ? AppColors.cardBorder
                : color.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Text(category.icon, style: const TextStyle(fontSize: 28)),
                if (isLocked)
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: Icon(
                      Icons.lock,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              category.displayName,
              style: TextStyle(
                fontSize: 11,
                color: isLocked ? AppColors.textHint : color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
