import 'dart:math';

import 'package:flutter/material.dart';
import 'package:color_picker/presentation/color_picker/widgets/color_preview.dart';
import 'package:color_picker/presentation/color_picker/widgets/channel_slider.dart';

class CmykPickerTab extends StatelessWidget {
  final Color color;
  final String hexString;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<String> onCopy;

  const CmykPickerTab({
    super.key,
    required this.color,
    required this.hexString,
    required this.onColorChanged,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final cmyk = _rgbToCmyk(color);
    final cmykString =
        'C:${cmyk.c.round()}% M:${cmyk.m.round()}% Y:${cmyk.y.round()}% K:${cmyk.k.round()}%';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ColorPreview(
              color: color,
              hexString: hexString,
              onCopy: () => onCopy(hexString),
            ),
            const SizedBox(height: 24),
            // CMYK value display
            GestureDetector(
              onTap: () => onCopy(cmykString),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        cmykString,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                    Icon(
                      Icons.copy,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // CMYK Sliders
            ChannelSliderDouble(
              label: 'C',
              value: cmyk.c,
              activeColor: Colors.cyan,
              onChanged: (v) => onColorChanged(
                _cmykToRgb(_CMYK(v, cmyk.m, cmyk.y, cmyk.k)),
              ),
            ),
            const SizedBox(height: 8),
            ChannelSliderDouble(
              label: 'M',
              value: cmyk.m,
              activeColor: Colors.pinkAccent,
              onChanged: (v) => onColorChanged(
                _cmykToRgb(_CMYK(cmyk.c, v, cmyk.y, cmyk.k)),
              ),
            ),
            const SizedBox(height: 8),
            ChannelSliderDouble(
              label: 'Y',
              value: cmyk.y,
              activeColor: Colors.yellow.shade700,
              onChanged: (v) => onColorChanged(
                _cmykToRgb(_CMYK(cmyk.c, cmyk.m, v, cmyk.k)),
              ),
            ),
            const SizedBox(height: 8),
            ChannelSliderDouble(
              label: 'K',
              value: cmyk.k,
              activeColor: Colors.grey.shade800,
              onChanged: (v) => onColorChanged(
                _cmykToRgb(_CMYK(cmyk.c, cmyk.m, cmyk.y, v)),
              ),
            ),
            const SizedBox(height: 32),
            // RGB equivalent
            _InfoSection(
              title: 'RGB Equivalent',
              items: [
                _InfoRow('Red', '${color.red}'),
                _InfoRow('Green', '${color.green}'),
                _InfoRow('Blue', '${color.blue}'),
              ],
            ),
            const SizedBox(height: 16),
            // HSV equivalent
            _InfoSection(
              title: 'HSV Equivalent',
              items: [
                _InfoRow('Hue', '${HSVColor.fromColor(color).hue.round()}°'),
                _InfoRow('Saturation',
                    '${(HSVColor.fromColor(color).saturation * 100).round()}%'),
                _InfoRow('Value',
                    '${(HSVColor.fromColor(color).value * 100).round()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoRow> items;

  const _InfoSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.label,
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(item.value,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
}

// CMYK conversion helpers
class _CMYK {
  final double c, m, y, k;
  const _CMYK(this.c, this.m, this.y, this.k);
}

_CMYK _rgbToCmyk(Color color) {
  final r = color.red / 255.0;
  final g = color.green / 255.0;
  final b = color.blue / 255.0;

  final k = 1.0 - max(r, max(g, b));
  if (k >= 1.0) return const _CMYK(0, 0, 0, 100);

  final c = (1.0 - r - k) / (1.0 - k);
  final m = (1.0 - g - k) / (1.0 - k);
  final y = (1.0 - b - k) / (1.0 - k);

  return _CMYK(
    (c * 100).clamp(0, 100),
    (m * 100).clamp(0, 100),
    (y * 100).clamp(0, 100),
    (k * 100).clamp(0, 100),
  );
}

Color _cmykToRgb(_CMYK cmyk) {
  final c = cmyk.c / 100.0;
  final m = cmyk.m / 100.0;
  final y = cmyk.y / 100.0;
  final k = cmyk.k / 100.0;

  final r = ((1.0 - c) * (1.0 - k) * 255).round().clamp(0, 255);
  final g = ((1.0 - m) * (1.0 - k) * 255).round().clamp(0, 255);
  final b = ((1.0 - y) * (1.0 - k) * 255).round().clamp(0, 255);

  return Color.fromARGB(255, r, g, b);
}
