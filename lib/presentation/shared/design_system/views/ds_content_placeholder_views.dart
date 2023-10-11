import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';

class DSErrorView extends StatelessWidget {
  final bool useScaffold;
  final String? scaffoldTitle;
  final bool expanded;
  final Widget? iconView;
  final String? refreshButtonText;
  final VoidCallback onRefresh;
  final String? title;
  final String? description;
  final TextStyle? titleTextStyle;
  final TextStyle? descriptionTextStyle;
  final EdgeInsetsGeometry? contentPadding;

  const DSErrorView({
    Key? key,
    this.useScaffold = false,
    this.scaffoldTitle,
    this.expanded = false,
    this.iconView,
    this.refreshButtonText,
    required this.onRefresh,
    this.title,
    this.description,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ContentPlaceholderScreen(
      useScaffold: useScaffold,
      scaffoldTitle: scaffoldTitle ?? context.l10n.error,
      expanded: expanded,
      iconView: iconView,
      fallbackIcon: null,
      title: title ?? context.l10n.defaultErrorMessage,
      description: description ?? context.l10n.defaultErrorPageDescription,
      refreshButtonText: refreshButtonText,
      onRefresh: onRefresh,
      titleTextStyle: titleTextStyle,
      descriptionTextStyle: descriptionTextStyle,
      contentPadding: contentPadding,
    );
  }
}

class DSEmptyView extends StatelessWidget {
  final bool useScaffold;
  final String? scaffoldTitle;
  final bool expanded;
  final Widget? iconView;
  final String? actionButtonText;
  final VoidCallback? onAction;
  final String? title;
  final String? description;
  final TextStyle? titleTextStyle;
  final TextStyle? descriptionTextStyle;
  final EdgeInsetsGeometry? contentPadding;

  const DSEmptyView({
    Key? key,
    this.useScaffold = false,
    this.scaffoldTitle,
    this.expanded = false,
    this.iconView,
    this.actionButtonText,
    this.onAction,
    this.title,
    this.description,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ContentPlaceholderScreen(
      useScaffold: useScaffold,
      scaffoldTitle: scaffoldTitle ?? '',
      expanded: expanded,
      iconView: iconView,
      fallbackIcon: null,
      title: title,
      description: description ?? context.l10n.defaultEmptyPageDescription,
      refreshButtonText: actionButtonText,
      onRefresh: onAction,
      titleTextStyle: titleTextStyle,
      descriptionTextStyle: descriptionTextStyle,
      contentPadding: contentPadding,
    );
  }
}

class DSNoInternetView extends StatelessWidget {
  final bool useScaffold;
  final String? scaffoldTitle;
  final bool expanded;
  final Widget? iconView;
  final VoidCallback? onRefresh;
  final String? title;
  final String? description;
  final TextStyle? titleTextStyle;
  final TextStyle? descriptionTextStyle;
  final EdgeInsetsGeometry? contentPadding;

  const DSNoInternetView({
    Key? key,
    this.useScaffold = false,
    this.scaffoldTitle,
    this.expanded = false,
    this.iconView,
    this.onRefresh,
    this.title,
    this.description,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ContentPlaceholderScreen(
      useScaffold: useScaffold,
      scaffoldTitle: scaffoldTitle ?? '',
      expanded: expanded,
      iconView: iconView,
      fallbackIcon: Icons.cloud_off,
      title: title ?? context.l10n.defaultNoInternetPageTitle,
      description: description ?? context.l10n.defaultNoInternetPageDescription,
      onRefresh: onRefresh,
      titleTextStyle: titleTextStyle,
      descriptionTextStyle: descriptionTextStyle,
      contentPadding: contentPadding,
    );
  }
}

class _ContentPlaceholderScreen extends StatelessWidget {
  final bool useScaffold;
  final String scaffoldTitle;

  final Widget? iconView;
  final IconData? fallbackIcon;
  final bool expanded;
  final String? title;
  final String? description;
  final String? refreshButtonText;
  final VoidCallback? onRefresh;
  final TextStyle? titleTextStyle;
  final TextStyle? descriptionTextStyle;
  final EdgeInsetsGeometry? contentPadding;

  const _ContentPlaceholderScreen({
    Key? key,
    required this.useScaffold,
    required this.scaffoldTitle,
    this.iconView,
    this.fallbackIcon,
    required this.expanded,
    required this.title,
    required this.description,
    this.refreshButtonText,
    required this.onRefresh,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.contentPadding,
  })  : assert(title != null || description != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = _ContentPlaceholderBody(
      iconView: iconView,
      icon: fallbackIcon,
      title: title,
      expanded: expanded,
      description: description,
      refreshButtonText: refreshButtonText,
      onRefresh: onRefresh,
      titleTextStyle: titleTextStyle,
      descriptionTextStyle: descriptionTextStyle,
      contentPadding: contentPadding,
    );
    return useScaffold
        ? Scaffold(
            appBar: AppBar(
              title: Text(scaffoldTitle),
            ),
            body: body,
          )
        : body;
  }
}

class _ContentPlaceholderBody extends StatelessWidget {
  static const kIconHeight = 115.0;

  final Widget? iconView;
  final IconData? icon;
  final bool expanded;
  final String? title;
  final String? description;
  final String? refreshButtonText;
  final VoidCallback? onRefresh;
  final TextStyle? titleTextStyle;
  final TextStyle? descriptionTextStyle;
  final EdgeInsetsGeometry? contentPadding;

  const _ContentPlaceholderBody({
    Key? key,
    this.iconView,
    this.icon,
    required this.expanded,
    required this.title,
    required this.description,
    this.refreshButtonText,
    required this.onRefresh,
    required this.titleTextStyle,
    required this.descriptionTextStyle,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (iconView != null || icon != null) ...[
          iconView ??
              Icon(
                icon,
                size: kIconHeight,
                color: Theme.of(context).colorScheme.primary,
              ),
          const SizedBox(height: Dimens.marginMedium),
        ],
        if (title != null) ...[
          Text(
            title!,
            style: titleTextStyle ?? Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimens.marginMedium),
        ],
        if (description != null) ...[
          Text(
            description!,
            style:
                descriptionTextStyle ?? Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Dimens.marginMedium),
        ],
      ],
    );

    return Padding(
      padding: contentPadding ?? const EdgeInsets.all(Dimens.marginLarge),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            expanded ? Expanded(child: content) : content,
            if (onRefresh != null)
              DSPrimaryButton(
                text: refreshButtonText ?? context.l10n.refresh,
                onPressed: onRefresh,
              ),
          ],
        ),
      ),
    );
  }
}
