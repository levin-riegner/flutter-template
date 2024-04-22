import 'package:flutter/material.dart';
import 'package:flutter_template/app/config/constants.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/app/navigation/util/poppable_mixin.dart';
import 'package:flutter_template/data/auth/repository/auth_repository.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_app_version.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatelessWidget with PoppableMixin {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => pop(context),
          ),
          title: const Text("Settings"),
        ),
        body: Column(
          children: [
            FilledButton(
              child: const Text("Account Details"),
              onPressed: () {
                const AccountDetailsRoute(name: "Alex").push(context);
              },
            ),
            // App Version
            const Padding(
              padding: EdgeInsets.all(Dimens.marginMedium),
              child: DSAppVersion(),
            ),
            // Leave a Review
            ListTile(
              title: const Text("Leave a Review"),
              onTap: () async {
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
            // Show Legal Licenses
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SizedBox.shrink();
                }
                final packageInfo = snapshot.data!;
                return ListTile(
                  title: Text(context.l10n.profileLegalLicenses),
                  onTap: () async {
                    showLicensePage(
                      context: context,
                      applicationName: packageInfo.appName,
                      applicationVersion:
                          "${packageInfo.version} (${packageInfo.buildNumber})",
                    );
                  },
                );
              },
            ),
            // TODO: Implement logout according to your needs
            // This is just a simple example to showcase the redirection to the login page
            ListTile(
              title: const Text("Logout"),
              onTap: () {
                getIt<AuthRepository>().clearSession().then(
                      (value) => context.go("/"),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
