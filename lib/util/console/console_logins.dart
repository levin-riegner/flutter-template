import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_loading_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ConsoleLogins extends StatefulWidget {
  const ConsoleLogins({Key? key}) : super(key: key);

  @override
  _ConsoleLoginsState createState() => _ConsoleLoginsState();
}

class _ConsoleLoginsState extends State<ConsoleLogins> {
  final List<_Login> logins = [
    _Login("Default", "alexq@levinriegner.com", "Test123456!"),
  ];

  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logins"),
      ),
      body: ListView.builder(
        itemCount: logins.length + (loading || error != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < logins.length) {
            final login = logins[index];
            return ListTile(
              title: Text(login.name),
              subtitle: Text("${login.email} / ${login.password}"),
              onTap: () => _performLogin(context, login),
            );
          } else if (loading) {
            return const ListTile(
              title: Center(child: DSLoadingIndicator()),
            );
          } else if (error != null) {
            return ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.red,
                BlendMode.color,
              ),
              child: ListTile(
                title: const Text("Error logging in"),
                subtitle: Text(error ?? ""),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _performLogin(BuildContext context, _Login login) async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      // TODO: Perform login operation
      // Navigate to Home
      if (!context.mounted) return;
      setState(() {
        loading = false;
      });
      context.go("/");
    } catch (e) {
      Flogger.w("Error logging in: $e");
      setState(() {
        loading = false;
        error = e.toString();
      });
    }
  }
}

class _Login {
  final String name;
  final String email;
  final String password;

  _Login(this.name, this.email, this.password);
}
