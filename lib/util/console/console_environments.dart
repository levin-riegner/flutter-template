import 'package:flutter/material.dart';
import 'package:color_picker/app/config/environment.dart';
import 'package:color_picker/util/dependencies.dart';

class ConsoleEnvironments extends StatefulWidget {
  const ConsoleEnvironments({super.key});

  @override
  _ConsoleEnvironmentsState createState() => _ConsoleEnvironmentsState();
}

class _ConsoleEnvironmentsState extends State<ConsoleEnvironments> {
  late Environment _selectedEnvironment = getIt.get<Environment>();

  @override
  Widget build(BuildContext context) {
    final environments = Environment.values();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Environments"),
      ),
      body: RadioGroup<Environment>(
        groupValue: _selectedEnvironment,
        onChanged: (environment) {
          if (environment != null) _setEnvironment(context, environment);
        },
        child: ListView.builder(
          itemCount: environments.length,
          itemBuilder: (context, index) {
            final environment = environments[index];
            return RadioListTile<Environment>(
              title: Text(environment.environmentName),
              value: environment,
            );
          },
        ),
      ),
    );
  }

  Future<void> _setEnvironment(BuildContext context, Environment environment) async {
    // Set new environment
    final previous = getIt.get<Environment>();
    getIt.unregister<Environment>(instance: previous);
    getIt.registerSingleton<Environment>(environment);
    setState(() {
      _selectedEnvironment = environment;
    });
    // TODO: Restart App
  }
}
