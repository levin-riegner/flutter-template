import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/dimens.dart';

class DSDialog extends StatelessWidget {
  final bool hasCloseButton;
  final Widget content;

  const DSDialog({
    Key? key,
    this.hasCloseButton = true,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(
        Dimens.marginLarge,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          Dimens.marginMedium,
        ),
        child: hasCloseButton
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: Navigator.of(context).pop,
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                  content,
                ],
              )
            : content,
      ),
    );
  }
}
