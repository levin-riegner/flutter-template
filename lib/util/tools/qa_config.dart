import 'package:flutter/foundation.dart';

class QaConfig with ChangeNotifier {
  bool _debugShowMaterialGrid = false;
  bool _showSemanticsDebugger = false;

  bool get debugShowMaterialGrid => _debugShowMaterialGrid;

  set debugShowMaterialGrid(bool value) {
    _debugShowMaterialGrid = value;
    notifyListeners();
  }

  bool get showSemanticsDebugger => _showSemanticsDebugger;

  set showSemanticsDebugger(bool value) {
    _showSemanticsDebugger = value;
    notifyListeners();
  }

  @override
  String toString() {
    return 'QaConfig{_debugShowMaterialGrid: $_debugShowMaterialGrid, _showSemanticsDebugger: $_showSemanticsDebugger}';
  }
}
