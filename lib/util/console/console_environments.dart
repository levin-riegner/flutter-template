import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/navigation/router/app_router.gr.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/util/dependencies.dart';

class ConsoleEnvironments extends StatefulWidget {
  @override
  _ConsoleEnvironmentsState createState() => _ConsoleEnvironmentsState();
}

class _ConsoleEnvironmentsState extends State<ConsoleEnvironments> {
  final currentEnvironment = getIt.get<Environment>();

  @override
  Widget build(BuildContext context) {
    final environments = Environment.values();
    return Scaffold(
      appBar: AppBar(
        title: Text("Environments"),
      ),
      body: ListView.builder(
        itemCount: environments.length,
        itemBuilder: (context, index) {
          final environment = environments[index];
          return RadioListTile<Environment>(
            title: Text(environment.name),
            value: environment,
            groupValue: currentEnvironment,
            onChanged: (environment) => _setEnvironment(context, environment!),
          );
        },
      ),
    );
  }

  _setEnvironment(BuildContext context, Environment environment) async {
    // Set new environment
    getIt.unregister<Environment>(instance: currentEnvironment);
    getIt.registerSingleton<Environment>(environment);
    // Restart App
    AutoRouter.of(context).root.popUntil((route) => false);
    AutoRouter.of(context).root.navigateNamed(Routes.articles);
  }
}
