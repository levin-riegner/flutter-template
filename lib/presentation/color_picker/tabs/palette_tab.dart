import 'package:flutter/material.dart';

class PaletteTab extends StatelessWidget {
  final Color seedColor;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<String> onCopy;

  const PaletteTab({
    super.key,
    required this.seedColor,
    required this.onColorSelected,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seed color display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: seedColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: seedColor.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                'Seed: ${_hex(seedColor)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: seedColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 28),
            // Light theme
            Text(
              'Light Theme',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap a swatch to select it, long-press to copy hex',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            _PaletteGrid(
              scheme: lightScheme,
              onColorSelected: onColorSelected,
              onCopy: onCopy,
              brightness: Brightness.light,
            ),
            const SizedBox(height: 28),
            // Dark theme
            Text(
              'Dark Theme',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Material 3 color scheme generated from seed',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            _PaletteGrid(
              scheme: darkScheme,
              onColorSelected: onColorSelected,
              onCopy: onCopy,
              brightness: Brightness.dark,
            ),
            const SizedBox(height: 28),
            // Complementary colors
            Text(
              'Harmonies',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _HarmonyRow(
              label: 'Complementary',
              colors: _complementary(seedColor),
              onColorSelected: onColorSelected,
              onCopy: onCopy,
            ),
            const SizedBox(height: 12),
            _HarmonyRow(
              label: 'Analogous',
              colors: _analogous(seedColor),
              onColorSelected: onColorSelected,
              onCopy: onCopy,
            ),
            const SizedBox(height: 12),
            _HarmonyRow(
              label: 'Triadic',
              colors: _triadic(seedColor),
              onColorSelected: onColorSelected,
              onCopy: onCopy,
            ),
            const SizedBox(height: 12),
            _HarmonyRow(
              label: 'Split-Complementary',
              colors: _splitComplementary(seedColor),
              onColorSelected: onColorSelected,
              onCopy: onCopy,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteGrid extends StatelessWidget {
  final ColorScheme scheme;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<String> onCopy;
  final Brightness brightness;

  const _PaletteGrid({
    required this.scheme,
    required this.onColorSelected,
    required this.onCopy,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    final roles = [
      _ColorRole('Primary', scheme.primary, scheme.onPrimary),
      _ColorRole('On Primary', scheme.onPrimary, scheme.primary),
      _ColorRole('Primary Container', scheme.primaryContainer,
          scheme.onPrimaryContainer),
      _ColorRole('Secondary', scheme.secondary, scheme.onSecondary),
      _ColorRole('On Secondary', scheme.onSecondary, scheme.secondary),
      _ColorRole('Secondary Container', scheme.secondaryContainer,
          scheme.onSecondaryContainer),
      _ColorRole('Tertiary', scheme.tertiary, scheme.onTertiary),
      _ColorRole('On Tertiary', scheme.onTertiary, scheme.tertiary),
      _ColorRole('Tertiary Container', scheme.tertiaryContainer,
          scheme.onTertiaryContainer),
      _ColorRole('Surface', scheme.surface, scheme.onSurface),
      _ColorRole('Surface Container', scheme.surfaceContainer,
          scheme.onSurface),
      _ColorRole('Error', scheme.error, scheme.onError),
    ];

    return Container(
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? Colors.grey.shade100
            : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: roles.map((role) {
          return GestureDetector(
            onTap: () => onColorSelected(role.color),
            onLongPress: () => onCopy(_hex(role.color)),
            child: Container(
              width: (MediaQuery.of(context).size.width - 48 - 16 - 18) / 4,
              height: 72,
              decoration: BoxDecoration(
                color: role.color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.2),
                ),
              ),
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      role.name,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: role.onColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _hex(role.color),
                    style: TextStyle(
                      fontSize: 7,
                      color: role.onColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HarmonyRow extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<String> onCopy;

  const _HarmonyRow({
    required this.label,
    required this.colors,
    required this.onColorSelected,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        Row(
          children: colors.map((c) {
            return Expanded(
              child: GestureDetector(
                onTap: () => onColorSelected(c),
                onLongPress: () => onCopy(_hex(c)),
                child: Container(
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _hex(c),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: c.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ColorRole {
  final String name;
  final Color color;
  final Color onColor;
  const _ColorRole(this.name, this.color, this.onColor);
}

String _hex(Color c) =>
    '#${c.value.toRadixString(16).substring(2).toUpperCase()}';

// Color harmony calculations
List<Color> _complementary(Color color) {
  final hsv = HSVColor.fromColor(color);
  return [
    color,
    hsv.withHue((hsv.hue + 180) % 360).toColor(),
  ];
}

List<Color> _analogous(Color color) {
  final hsv = HSVColor.fromColor(color);
  return [
    hsv.withHue((hsv.hue - 30 + 360) % 360).toColor(),
    color,
    hsv.withHue((hsv.hue + 30) % 360).toColor(),
  ];
}

List<Color> _triadic(Color color) {
  final hsv = HSVColor.fromColor(color);
  return [
    color,
    hsv.withHue((hsv.hue + 120) % 360).toColor(),
    hsv.withHue((hsv.hue + 240) % 360).toColor(),
  ];
}

List<Color> _splitComplementary(Color color) {
  final hsv = HSVColor.fromColor(color);
  return [
    color,
    hsv.withHue((hsv.hue + 150) % 360).toColor(),
    hsv.withHue((hsv.hue + 210) % 360).toColor(),
  ];
}
