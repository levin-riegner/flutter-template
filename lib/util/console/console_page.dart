import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ConsolePage extends StatelessWidget {
  const ConsolePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = ListView(
      children: [
        ListTile(
          title: const Text("Logs"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () => LogConsole.open(context),
        ),
        ListTile(
          title: const Text("Environments"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () =>
              _navigateTo(context, const ConsoleEnvironmentsRoute().location),
        ),
        ListTile(
          title: const Text("Logins"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () =>
              _navigateTo(context, const ConsoleLoginsRoute().location),
        ),
        ListTile(
          title: const Text("QA Configs"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () =>
              _navigateTo(context, const ConsoleQaConfigRoute().location),
        ),
        ListTile(
          title: const Text("Deeplinks"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () =>
              _navigateTo(context, const ConsoleDeeplinksRoute().location),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("QA Console"),
      ),
      body: body,
    );
  }

  _navigateTo(BuildContext context, String route) {
    GoRouter.of(context).push(route);
  }
}
