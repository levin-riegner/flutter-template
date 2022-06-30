import 'package:shared_preferences/shared_preferences.dart';

const _cachePolicyKeyPrefix = "cachePolicy_";

class CachePolicyService {
  Future<bool> shouldUpdate(CachePolicyModel model, {String? id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastUpdated = prefs.getInt(model.toKey(id: id));
    if (lastUpdated == null) return true;
    final now = DateTime.now().millisecondsSinceEpoch;
    return lastUpdated + model.refreshPeriodInMs() < now;
  }

  Future<void> setUpdated(CachePolicyModel model, {String? id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        model.toKey(id: id), DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final cachePolicyKeys =
        keys.where((element) => element.startsWith(_cachePolicyKeyPrefix));
    await Future.wait(cachePolicyKeys.map((e) => prefs.remove(e)));
  }
}

enum CachePolicyModel { articles }

extension CachePolicyModelX on CachePolicyModel {
  int refreshPeriodInMs() {
    switch (this) {
      case CachePolicyModel.articles:
        return 24 * 60 * 60 * 1000; // Every 24h
    }
  }

  String toKey({required String? id}) {
    return _cachePolicyKeyPrefix + toString() + (id != null ? "_$id" : "");
  }
}
