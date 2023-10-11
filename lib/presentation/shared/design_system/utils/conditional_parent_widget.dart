import 'package:flutter/widgets.dart';

/// Conditionally wrap a subtree with a parent widget without breaking the code tree.
///
/// [condition]: the condition depending on which the subtree [child] is wrapped with the parent.
/// [child]: The subtree that should always be build.
/// [parentBuilder]: builds the parent with the subtree [child] iff [condition] is true.
///
/// ___________
/// Usage:
/// ```dart
/// return ConditionalParentWidget(
///   condition: shouldIncludeParent,
///   child: Widget1(
///     child: Widget2(
///       child: Widget3(),
///     ),
///   ),
///   parentBuilder: (Widget child) => SomeParentWidget(child: child),
///);
/// ```
///
/// ___________
/// Instead of:
/// ```dart
/// Widget child = Widget1(
///   child: Widget2(
///     child: Widget3(),
///   ),
/// );
///
/// return shouldIncludeParent ? SomeParentWidget(child: child) : child;
/// ```
///
class ConditionalParentWidget extends StatelessWidget {
  const ConditionalParentWidget({
    Key? key,
    required this.condition,
    required this.child,
    required this.parentBuilder,
  }) : super(key: key);

  /// The [child] which should be conditionally wrapped by the parent.
  ///
  /// If [condition] is false, this Widget will be returned directly.
  /// If [condition] is true, this Widget will be passed to [parentBuilder] which will be returned.
  final Widget child;

  /// The [condition] which controls whether the [child] is returned directly or passed to [parentBuilder].
  final bool condition;

  /// The [parentBuilder] will be called only when [condition] is true.
  /// Its [child] parameter is the [child] passed to [ConditionalParentWidget].
  final Widget Function(Widget child) parentBuilder;

  @override
  Widget build(BuildContext context) {
    return condition ? parentBuilder(child) : child;
  }
}
