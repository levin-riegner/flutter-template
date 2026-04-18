import 'package:flutter/widgets.dart';
import 'package:color_picker/app/l10n/l10n.dart';

export 'package:flutter_template/app/l10n/strings.dart';

extension StringsX on BuildContext {
  Strings get l10n => Strings.of(this)!;
}