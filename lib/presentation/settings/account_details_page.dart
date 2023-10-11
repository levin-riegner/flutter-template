import 'package:flutter/material.dart';

class AccountDetailsPage extends StatelessWidget {
  final String? name;
  const AccountDetailsPage({
    this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account Details")),
      body: Center(
        child: Text("Name: $name"),
      ),
    );
  }
}
