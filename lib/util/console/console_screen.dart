import 'package:flutter/material.dart';
import 'package:flutter_template/util/console/console_environments.dart';
import 'package:flutter_template/util/console/console_logins.dart';
import 'package:flutter_template/util/console/console_qa_config.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ConsoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final body = ListView(
      children: [
        ListTile(
          title: Text("Logs"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () => LogConsole.open(context),
        ),
        ListTile(
          title: Text("Environments"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () => _navigateTo(context, ConsoleEnvironments()),
        ),
        ListTile(
          title: Text("Logins"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () => _navigateTo(context, ConsoleLogins()),
        ),
        ListTile(
          title: Text("QA Configs"),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () => _navigateTo(context, ConsoleQaConfigs()),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("QA Console"),
      ),
      body: body,
    );
  }

  _navigateTo(BuildContext context, Widget widget) {
    final route = MaterialPageRoute(builder: (_) => widget);
    Navigator.of(context).push(route);
  }
}
