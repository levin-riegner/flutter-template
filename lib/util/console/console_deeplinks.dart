import 'package:flutter/material.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/navigation/deeplink_manager.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ConsoleDeeplinks extends StatefulWidget {
  const ConsoleDeeplinks({super.key});

  @override
  State<ConsoleDeeplinks> createState() => _ConsoleDeeplinksState();
}

class _ConsoleDeeplinksState extends State<ConsoleDeeplinks> {
  final TextEditingController _deeplinkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final environment = getIt.get<Environment>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deeplinks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Use any link to navigate to an app screen, these can be:\n"
              "- App URLs (ie: ${environment.deepLinkScheme}://settings)\n"
              "- Branch Deeplink URLs\n"
              "- Websites (ie: https://)\n\n"
              "An unsupported deeplink will redirect to Home or Login.\n"
              "An invalid scheme (ie: unknown://) will be ignored.",
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _deeplinkController,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(
                hintText: "Enter a deeplink",
              ),
              autocorrect: false,
              enableSuggestions: false,
            ),
            const SizedBox(height: 16),
            FilledButton(
              child: const Text("Navigate"),
              onPressed: () {
                final deeplinkManager = getIt.get<DeepLinkManager>();
                try {
                  final url = _deeplinkController.text;
                  Flogger.i("Navigating to deeplink: $url");
                  if (url.contains(".app.link/")) {
                    // TODO: Branch
                    // FlutterBranchSdk.handleDeepLink(url);
                  } else {
                    deeplinkManager.handleDeepLink(Uri.parse(url));
                  }
                } catch (e) {
                  Flogger.w("Error parsing deeplink: $e");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
