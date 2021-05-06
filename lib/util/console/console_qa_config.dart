import 'package:flutter/material.dart';
import 'package:flutter_template/util/tools/qa_config.dart';
import 'package:provider/provider.dart';

class ConsoleQaConfigs extends StatefulWidget {
  @override
  _ConsoleQaConfigsState createState() => _ConsoleQaConfigsState();
}

class _ConsoleQaConfigsState extends State<ConsoleQaConfigs> {
  @override
  Widget build(BuildContext context) {
    final config = Provider.of<QaConfig>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("QA Config"),
      ),
      body: ListView(
        children: [
          CheckboxListTile(
            title: Text("Show Material Grid"),
            value: config.debugShowMaterialGrid,
            onChanged: (isChecked) {
              config.debugShowMaterialGrid = isChecked ?? false;
            },
          ),
          CheckboxListTile(
            title: Text("Accessibility Mode"),
            value: config.showSemanticsDebugger,
            onChanged: (isChecked) {
              config.showSemanticsDebugger = isChecked ?? false;
            },
          ),
        ],
      ),
    );
  }
}
