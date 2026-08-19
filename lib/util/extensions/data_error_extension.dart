import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/data/shared/model/error/data_error.dart';

extension DataErrorLocalized on DataError {
  String localizedMessage(BuildContext context) {
    return when(
      unknown: (error) => toString(),
      apiError: (code, reason) => toString(),
      notFound: () => context.l10n.networkErrorNotFound,
      noInternet: () => context.l10n.networkErrorNoInternet,
      badInternet: () => context.l10n.networkErrorBadInternet,
      serverTimeout: () => context.l10n.networkErrorServerTimeout,
      badCertificate: () => context.l10n.networkErrorBadCertificate,
    );
  }
}
