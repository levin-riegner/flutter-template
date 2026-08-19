import 'package:flutter/widgets.dart';
import 'package:swiss_ai/app/l10n/l10n.dart';

export 'package:swiss_ai/app/l10n/strings.dart';

extension StringsX on BuildContext {
  Strings get l10n => Strings.of(this)!;
}