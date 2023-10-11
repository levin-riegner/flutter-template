import 'package:flutter/material.dart';

class DSOpacityGestureDetector extends StatefulWidget {
  final VoidCallback? onTap;
  final String? semanticLabel;
  final Widget child;

  const DSOpacityGestureDetector({
    Key? key,
    required this.onTap,
    this.semanticLabel,
    required this.child,
  }) : super(key: key);

  @override
  State<DSOpacityGestureDetector> createState() =>
      _DSOpacityGestureDetectorState();
}

class _DSOpacityGestureDetectorState extends State<DSOpacityGestureDetector> {
  static const double _maxOpacity = 1;
  static const double _minOpacity = 0.4;
  static const _animationCurve = Curves.easeInOutCubic;
  static const _animationDuration = Duration(milliseconds: 200);

  double opacity = _maxOpacity;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        onTap: () {
          if (widget.onTap == null) return;
          setState(() {
            opacity = _maxOpacity;
          });
          widget.onTap!();
        },
        onTapDown: (details) {
          if (widget.onTap == null) return;
          setState(() {
            opacity = _minOpacity;
          });
        },
        onTapCancel: () {
          if (widget.onTap == null) return;
          setState(() {
            opacity = _maxOpacity;
          });
        },
        child: AnimatedOpacity(
          opacity: opacity,
          duration: _animationDuration,
          curve: _animationCurve,
          child: widget.child,
        ),
      ),
    );
  }
}
