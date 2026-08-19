import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/anims.dart';

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
        child: Text("Name: $name").animate().rotate(
              duration: Anims.defaultDuration,
              curve: Anims.defaultCurve,
            ),
      ),
    );
  }
}
