import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class EmailOpener {
  const EmailOpener._();

  static Future<void> openDefaultApp() async {
    if (Platform.isAndroid) {
      await const AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.APP_EMAIL',
          flags: [
            Flag.FLAG_ACTIVITY_NEW_TASK,
          ]).launch();
    } else if (Platform.isIOS) {
      await launchUrl(
        Uri.parse("message://"),
      );
    }
  }
}
