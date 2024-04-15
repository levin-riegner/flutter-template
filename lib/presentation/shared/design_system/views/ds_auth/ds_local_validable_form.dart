import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_auth/ds_local_validable_text_field.dart';

class DSLocalValidableForm extends StatelessWidget {
  final List<DSLocalValidableTextField> fields;
  final double verticalSpacing;
  final CrossAxisAlignment crossAxisAlignment;

  const DSLocalValidableForm({
    super.key,
    required this.fields,
    this.verticalSpacing = Dimens.marginMedium,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: fields
          .mapIndexed<Widget>(
            (index, element) => Padding(
              padding: EdgeInsets.only(
                bottom:
                    index == fields.length - 1 ? Dimens.zero : verticalSpacing,
              ),
              child: element,
            ),
          )
          .toList(),
    );
  }
}
