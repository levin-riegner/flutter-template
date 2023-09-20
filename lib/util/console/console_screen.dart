import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ConsoleScreen extends StatelessWidget {
  const ConsoleScreen({Key? key}) : super(key: key);

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
              _navigateTo(context, ConsoleEnvironmentsRoute().location),
        ),
        ListTile(
          title: const Text("Logins"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () => _navigateTo(context, ConsoleLoginsRoute().location),
        ),
        ListTile(
          title: const Text("QA Configs"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () => _navigateTo(context, ConsoleQaConfigsRoute().location),
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
    GoRouter.of(context).go(route);
  }
}
