import 'dart:io';

import 'package:flutter/widgets.dart';

abstract class PlatformAwareWidget<I extends Widget, A extends Widget>
    extends StatelessWidget {
  const PlatformAwareWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Platform.isIOS ? buildIosWidget(context) : buildAndroidWidget(context);

  I buildIosWidget(BuildContext context);

  A buildAndroidWidget(BuildContext context);
}
