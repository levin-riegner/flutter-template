import 'package:app_versioning/app_versioning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/navigator_holder.dart';
import 'package:flutter_template/presentation/shared/design_system/theme/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_button.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_dialog.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:logging_flutter/logging_flutter.dart';

class AppUpdater {
  final AppVersioning _appVersioning;

  const AppUpdater(this._appVersioning);

  Future<void> performUpdateIfAvailable() async {
    // Check App Update Available
    final appUpdateInfo = await _appVersioning.getAppUpdateInfo();
    Flogger.i("Got app update info: $appUpdateInfo");
    final isOptionalUpdate =
        appUpdateInfo.updateType != AppUpdateType.Mandatory;
    if (appUpdateInfo.isUpdateAvailable) {
      final context = NavigatorHolder.rootNavigatorKey.currentState?.context;
      if (context == null || !context.mounted) return;
      Flogger.i("Showing app update dialog");
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return DSDialog(
            hasCloseButton: isOptionalUpdate,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isOptionalUpdate) Dimens.boxSmall,
                Text(
                  context.l10n.dialogAppUpdateTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Dimens.boxXSmall,
                Text(
                  context.l10n.dialogAppUpdateDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Dimens.boxLarge,
                Column(
                  children: [
                    DSPrimaryButton(
                      text: context.l10n.dialogAppUpdateConfirmationButton,
                      onPressed: () {
                        Flogger.i("Launching update");
                        _appVersioning.launchUpdate(
                            updateInBackground: isOptionalUpdate);
                      },
                    ),
                    if (isOptionalUpdate) ...[
                      Dimens.boxSmall,
                      DSTextButton(
                        text: context.l10n.dialogAppUpdateDismissButton,
                        onPressed: context.router.pop,
                      ),
                    ]
                  ],
                ),
              ],
            ),
          );
        },
        barrierDismissible: isOptionalUpdate,
      );
    }
  }
}
