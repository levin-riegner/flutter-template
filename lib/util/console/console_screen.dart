import 'package:flutter/material.dart';
import 'package:flutter_template/util/console/console_environments.dart';
import 'package:flutter_template/util/console/console_logins.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:lr_design_system/views/ds_list_item_action.dart';

class ConsoleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final body = ListView(
      children: [
        DSListItemAction(
          text: "Logs",
          type: DSListItemActionType.navigation,
          onPressed: () => LogConsole.open(context),
        ),
        DSListItemAction(
          text: "Environments",
          type: DSListItemActionType.navigation,
          onPressed: () => _navigateTo(context, ConsoleEnvironments()),
        ),
        DSListItemAction(
          text: "Logins",
          type: DSListItemActionType.navigation,
          onPressed: () => _navigateTo(context, ConsoleLogins()),
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
