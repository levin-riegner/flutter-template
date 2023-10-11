import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler show openAppSettings;

class PermissionsService {
  /// Check the status of a specific [Permission]
  Future<PermissionStatus> status(Permission permission) {
    return permission.status;
  }

  /// Open the app settings.
  Future<bool> openAppSettings() {
    return permission_handler.openAppSettings();
  }

  /// Request permissions for a single permission.
  Future<PermissionStatus> request(Permission permission) {
    return permission.request();
  }
}
