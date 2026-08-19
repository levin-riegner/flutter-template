import 'package:flutter/material.dart';

class ColorPreview extends StatelessWidget {
  final Color color;
  final String hexString;
  final VoidCallback onCopy;

  const ColorPreview({
    super.key,
    required this.color,
    required this.hexString,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final luminance = color.computeLuminance();
    final textColor = luminance > 0.5 ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: onCopy,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hexString,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy, size: 14, color: textColor.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  Text(
                    'Tap to copy',
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
