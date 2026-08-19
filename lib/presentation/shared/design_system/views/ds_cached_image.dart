import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/conditional_parent_widget.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_loading_indicator.dart';

class DSCachedImage extends StatelessWidget {
  final String? imageUrl;
  final String? semanticsLabel;
  final BoxFit? fit;
  final Color? color;
  final BlendMode colorBlendMode;
  final double? borderRadius;
  final double? width;
  final double? height;

  // Setting border color will display a border around the image
  final Color? borderColor;
  final double borderWidth;

  const DSCachedImage({
    super.key,
    required this.imageUrl,
    this.semanticsLabel,
    this.fit,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
    this.borderRadius,
    this.width,
    this.height,
    this.borderColor,
    this.borderWidth = Dimens.borderSmall,
  });

  @override
  Widget build(BuildContext context) {
    return _BorderConditionalWrapper(
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      child: imageUrl?.isNotEmpty == true
          ? _Image(
              imageUrl: imageUrl!,
              semanticsLabel: semanticsLabel,
              fit: fit,
              color: color,
              colorBlendMode: colorBlendMode,
              width: width,
              height: height,
            )
          : _Placeholder(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).disabledColor,
    );
  }
}

class _Image extends StatelessWidget {
  final String imageUrl;
  final String? semanticsLabel;
  final BoxFit? fit;
  final Color? color;
  final BlendMode colorBlendMode;
  final double? width;
  final double? height;

  const _Image({
    required this.imageUrl,
    this.semanticsLabel,
    this.fit,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ConditionalParentWidget(
      condition: semanticsLabel != null && semanticsLabel!.isNotEmpty,
      parentBuilder: (child) {
        return Semantics(label: semanticsLabel, child: child);
      },
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) {
          return const Center(child: DSLoadingIndicator());
        },
        errorWidget: (context, error, stackTrace) {
          return _Placeholder();
        },
        color: color,
        colorBlendMode: colorBlendMode,
      ),
    );
  }
}

class _BorderConditionalWrapper extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final Color? borderColor;
  final double borderWidth;

  const _BorderConditionalWrapper({
    required this.child,
    this.borderRadius,
    this.borderColor,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConditionalParentWidget(
      condition: (borderRadius != null && borderRadius! > 0) ||
          (borderColor != null && borderWidth > 0),
      parentBuilder: (child) {
        return Container(
          padding: borderColor != null
              ? EdgeInsets.all(borderWidth)
              : EdgeInsets.zero,
          decoration: borderColor != null
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius!),
                  color: borderColor,
                )
              : null,
          child: borderRadius != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius!),
                  child: child,
                )
              : child,
        );
      },
      child: child,
    );
  }
}
