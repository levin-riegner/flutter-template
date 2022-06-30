import 'package:flutter/material.dart';
import 'package:flutter_template/util/tools/qa_config.dart';
import 'package:provider/provider.dart';

class ConsoleQaConfigs extends StatefulWidget {
  const ConsoleQaConfigs({Key? key}) : super(key: key);

  @override
  _ConsoleQaConfigsState createState() => _ConsoleQaConfigsState();
}

class _ConsoleQaConfigsState extends State<ConsoleQaConfigs> {
  @override
  Widget build(BuildContext context) {
    final config = Provider.of<QaConfig>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("QA Config"),
      ),
      body: ListView(
        children: [
          CheckboxListTile(
            title: const Text("Show Material Grid"),
            value: config.debugShowMaterialGrid,
            onChanged: (isChecked) {
              config.debugShowMaterialGrid = isChecked ?? false;
            },
          ),
          CheckboxListTile(
            title: const Text("Accessibility Mode"),
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
