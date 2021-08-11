import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/router/app_router.gr.dart';
import 'package:flutter_template/app/navigation/routes.dart';

class ConsoleLogins extends StatefulWidget {
  @override
  _ConsoleLoginsState createState() => _ConsoleLoginsState();
}

class _ConsoleLoginsState extends State<ConsoleLogins> {
  final List<_Login> logins = [
    _Login("Default", "alexq@levinriegner.com", "Test123456"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logins"),
      ),
      body: ListView.builder(
        itemCount: logins.length,
        itemBuilder: (context, index) {
          final login = logins[index];
          return ListTile(
            title: Text(login.name),
            subtitle: Text("${login.email} / ${login.password}"),
            onTap: () => _performLogin(context, login),
          );
        },
      ),
    );
  }

  _performLogin(BuildContext context, _Login login) async {
    // TODO: Perform login operation
    // TODO: Navigate to Home
    AutoRouter.of(context).root.navigateNamed(Routes.articles);
  }
}

class _Login {
  final String name;
  final String email;
  final String password;

  _Login(this.name, this.email, this.password);
}
