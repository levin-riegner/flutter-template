import 'dart:math';

import 'package:flutter/material.dart';

class ColorWheel extends StatelessWidget {
  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;

  const ColorWheel({
    super.key,
    required this.hsvColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 240,
          width: 240,
          child: _ColorWheelPainterWidget(
            hsvColor: hsvColor,
            onColorChanged: onColorChanged,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(Icons.brightness_low, size: 20),
            Expanded(
              child: Slider(
                value: hsvColor.value,
                onChanged: (v) => onColorChanged(hsvColor.withValue(v)),
              ),
            ),
            const Icon(Icons.brightness_high, size: 20),
          ],
        ),
      ],
    );
  }
}

class _ColorWheelPainterWidget extends StatefulWidget {
  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;

  const _ColorWheelPainterWidget({
    required this.hsvColor,
    required this.onColorChanged,
  });

  @override
  State<_ColorWheelPainterWidget> createState() =>
      _ColorWheelPainterWidgetState();
}

class _ColorWheelPainterWidgetState extends State<_ColorWheelPainterWidget> {
  void _handlePan(Offset localPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final offset = localPosition - center;
    final distance = offset.distance;

    if (distance > radius) return;

    final hue = (atan2(offset.dy, offset.dx) * 180 / pi + 360) % 360;
    final saturation = (distance / radius).clamp(0.0, 1.0);

    widget.onColorChanged(
      widget.hsvColor.withHue(hue).withSaturation(saturation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onTapDown: (details) => _handlePan(details.localPosition, size),
          onPanStart: (details) => _handlePan(details.localPosition, size),
          onPanUpdate: (details) => _handlePan(details.localPosition, size),
          child: CustomPaint(
            size: size,
            painter: _WheelPainter(hsvColor: widget.hsvColor),
          ),
        );
      },
    );
  }
}

class _WheelPainter extends CustomPainter {
  final HSVColor hsvColor;

  _WheelPainter({required this.hsvColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (double angle = 0; angle < 360; angle += 1) {
      for (double sat = 0; sat <= 1.0; sat += 0.01) {
        final paint = Paint()
          ..color = HSVColor.fromAHSV(1.0, angle, sat, hsvColor.value).toColor()
          ..strokeWidth = 3;

        final rad = angle * pi / 180;
        final x = center.dx + cos(rad) * sat * radius;
        final y = center.dy + sin(rad) * sat * radius;
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }

    final selectorRad = hsvColor.hue * pi / 180;
    final selectorX =
        center.dx + cos(selectorRad) * hsvColor.saturation * radius;
    final selectorY =
        center.dy + sin(selectorRad) * hsvColor.saturation * radius;
    final selectorPos = Offset(selectorX, selectorY);

    canvas.drawCircle(
      selectorPos,
      12,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      selectorPos,
      10,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_WheelPainter oldDelegate) =>
      oldDelegate.hsvColor != hsvColor;
}
