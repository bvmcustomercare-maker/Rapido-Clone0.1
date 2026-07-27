import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/logger.dart';

enum PermissionType {
  location,
  notifications,
}

/// Abstract permission manager interface
abstract class PermissionService {
  Future<bool> isPermissionGranted(PermissionType type);
  Future<bool> requestPermission(PermissionType type);
}

/// Stubbed/Offline Permission Service implementation for RideFlow (teck-stack.md §10)
class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> isPermissionGranted(PermissionType type) async {
    AppLogger.d('Checking stub permission status for: $type');
    return true; // Auto grant in offline simulator mode
  }

  @override
  Future<bool> requestPermission(PermissionType type) async {
    AppLogger.d('Requesting stub permission for: $type');
    return true;
  }
}

/// Riverpod provider for PermissionService
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionServiceImpl();
});
