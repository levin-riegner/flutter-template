import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(ArticlesRoute().location);
            }
          },
        ),
        title: const Text("Settings"),
      ),
      body: Center(
        child: FilledButton(
          child: const Text("Account Details"),
          onPressed: () {
            context.push(AccountDetailsRoute(username: "Alex").location);
          },
        ),
      ),
    );
  }
}
