import 'package:flutter/material.dart';
import 'package:flutter_template/app/config/constants.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:logging_flutter/logging_flutter.dart';

class BottomNavigationPage extends StatelessWidget {
  const BottomNavigationPage({
    required this.navigationShell,
    super.key,
  });

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Template"),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () async {
              // In-app review
              // TODO: Move to helper
              try {
                final InAppReview inAppReview = InAppReview.instance;
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                } else {
                  inAppReview.openStoreListing(
                    appStoreId: Constants.appstoreAppId,
                  );
                }
              } catch (e) {
                Flogger.i("Error requesting app review: $e");
              }
            },
          ),
          IconButton(
            onPressed: () {
              context.push(SettingsRoute().location);
            },
            icon: const Icon(Icons.settings),
          ),
          // TODO: Move to settings
          // const Padding(
          //   padding: EdgeInsets.all(Dimens.marginMedium),
          //   child: DSAppVersion(),
          // )
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: "Articles",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman),
            label: "Blank",
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  /// Navigate to the current location of the branch at the provided index when
  /// tapping an item in the BottomNavigationBar.
  void _onTap(BuildContext context, int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
