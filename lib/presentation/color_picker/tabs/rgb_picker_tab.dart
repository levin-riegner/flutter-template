import 'package:flutter/material.dart';
import 'package:color_picker/presentation/color_picker/widgets/color_preview.dart';
import 'package:color_picker/presentation/color_picker/widgets/color_wheel.dart';
import 'package:color_picker/presentation/color_picker/widgets/channel_slider.dart';

class RgbPickerTab extends StatelessWidget {
  final HSVColor hsvColor;
  final Color color;
  final String hexString;
  final ValueChanged<HSVColor> onColorChanged;
  final VoidCallback onCopyHex;

  const RgbPickerTab({
    super.key,
    required this.hsvColor,
    required this.color,
    required this.hexString,
    required this.onColorChanged,
    required this.onCopyHex,
  });

  static const _presets = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
    Colors.black,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ColorPreview(
              color: color,
              hexString: hexString,
              onCopy: onCopyHex,
            ),
            const SizedBox(height: 32),
            ColorWheel(
              hsvColor: hsvColor,
              onColorChanged: onColorChanged,
            ),
            const SizedBox(height: 32),
            // RGB Sliders
            ChannelSlider(
              label: 'R',
              value: color.red,
              activeColor: Colors.red,
              onChanged: (v) => onColorChanged(HSVColor.fromColor(
                Color.fromARGB(255, v, color.green, color.blue),
              )),
            ),
            const SizedBox(height: 8),
            ChannelSlider(
              label: 'G',
              value: color.green,
              activeColor: Colors.green,
              onChanged: (v) => onColorChanged(HSVColor.fromColor(
                Color.fromARGB(255, color.red, v, color.blue),
              )),
            ),
            const SizedBox(height: 8),
            ChannelSlider(
              label: 'B',
              value: color.blue,
              activeColor: Colors.blue,
              onChanged: (v) => onColorChanged(HSVColor.fromColor(
                Color.fromARGB(255, color.red, color.green, v),
              )),
            ),
            const SizedBox(height: 24),
            // Presets
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Presets',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presets.map((c) {
                return GestureDetector(
                  onTap: () => onColorChanged(HSVColor.fromColor(c)),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: c.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
