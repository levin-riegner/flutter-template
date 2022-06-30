import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: const Text("Navigate to detail"),
        onPressed: () => AutoRouter.of(context).pushNamed(
          Routes.settingsDetails,
        ),
      ),
    );
  }
}
