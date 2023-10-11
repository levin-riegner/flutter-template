import 'package:shake/shake.dart';

class ShakeManager {
  static ShakeDetector? _shakeDetector;

  static void init({
    required void Function() onShake,
    bool listen = true,
  }) {
    _shakeDetector = ShakeDetector.autoStart(
      shakeThresholdGravity: 2,
      onPhoneShake: onShake,
    );
    if (listen) {
      _shakeDetector?.startListening();
    }
  }

  static bool startListening() {
    _shakeDetector?.startListening();
    return _shakeDetector != null;
  }

  static bool stopListening() {
    _shakeDetector?.stopListening();
    return _shakeDetector != null;
  }
}
