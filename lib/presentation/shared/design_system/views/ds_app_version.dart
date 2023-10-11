import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DSAppVersion extends StatelessWidget {
  final TextStyle? textStyle;

  const DSAppVersion({
    Key? key,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, data) {
        if (!data.hasData) return Container();
        final info = data.data!;
        return Text(
          "${info.version} (${info.buildNumber})",
          style: textStyle ??
              Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme.of(context).disabledColor),
        );
      },
    );
  }
}
