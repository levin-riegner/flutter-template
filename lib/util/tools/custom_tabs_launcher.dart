import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as fallback;

class CustomTabsLauncher {
  CustomTabsLauncher._internal();

  factory CustomTabsLauncher() => instance;

  static CustomTabsLauncher instance = CustomTabsLauncher._internal();

  Future<bool> launchURL(
    String url, {
    BuildContext? context,
  }) async {
    try {
      await launchUrl(
        Uri.parse(url),
        prefersDeepLink: true,
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor:
                context != null ? Theme.of(context).colorScheme.primary : null,
            navigationBarColor: context != null
                ? Theme.of(context).colorScheme.secondary
                : null,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          instantAppsEnabled: false,
          animations: CustomTabsSystemAnimations.slideIn(),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor:
              context != null ? Theme.of(context).colorScheme.primary : null,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );

      return true;
    } catch (e) {
      Flogger.i("Failed to launch url $url with custom_tabs: $e");
      return _launchFallbackUrl(url);
    }
  }

  Future<bool> _launchFallbackUrl(String url) async {
    try {
      return await fallback.launchUrl(
        Uri.parse(url),
      );
    } catch (e) {
      // An exception is thrown if the device doesn't have a browser installed.
      Flogger.w("Failed to launch url $url with url_launcher: $e");
      return false;
    }
  }
}
