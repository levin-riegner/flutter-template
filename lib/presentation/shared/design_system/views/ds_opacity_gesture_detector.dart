import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/conditional_parent_widget.dart';

class DSOpacityGestureDetector extends StatefulWidget {
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool enabled;
  final bool fullWidth;
  final Widget child;

  const DSOpacityGestureDetector({
    Key? key,
    required this.onTap,
    this.semanticLabel,
    this.enabled = true,
    this.fullWidth = true,
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
    return ConditionalParentWidget(
      condition: widget.fullWidth,
      parentBuilder: (child) => SizedBox(
        width: double.infinity,
        child: child,
      ),
      child: Semantics(
        button: true,
        enabled: widget.enabled,
        label: widget.semanticLabel,
        child: GestureDetector(
          onTap: () {
            if (widget.onTap == null || !widget.enabled) return;
            setState(() {
              opacity = _maxOpacity;
            });
            widget.onTap!();
          },
          onTapDown: (details) {
            if (widget.onTap == null || !widget.enabled) return;
            setState(() {
              opacity = _minOpacity;
            });
          },
          onTapCancel: () {
            if (widget.onTap == null || !widget.enabled) return;
            setState(() {
              opacity = _maxOpacity;
            });
          },
          child: Container(
            // Add a transparent box to allow hitting the whole area of the widget
            decoration: const BoxDecoration(color: Colors.transparent),
            child: AnimatedOpacity(
              opacity: opacity,
              duration: _animationDuration,
              curve: _animationCurve,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
