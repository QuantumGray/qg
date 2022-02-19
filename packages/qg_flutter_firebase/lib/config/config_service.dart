import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qg_flutter_base/base/utils/utils.dart';
import 'package:qg_flutter_base/repositories/base_repository.dart';
import 'package:qg_flutter_firebase/store/store_service.dart';

final pConfigRepository =
    Provider<ConfigRepository>((ref) => ConfigRepository(ref.read, {}));

class ConfigRepository extends BaseRepository {
  final Map<String, String> defaultConfigs;

  ConfigRepository(Reader read, this.defaultConfigs) : super(read) {
    config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    _setDefaults();
    _fetchAndAcitvate();
  }

  Future<void> _fetchAndAcitvate() =>
      compute<void, void>((_) => config.fetchAndActivate(), null);

  final RemoteConfig config = RemoteConfig.instance;

  StoreRepository get store => read(pStoreRepository);

  // DID-SEE-ONBOARDING
  set didSeeOnboarding(bool value) =>
      store.setSingleObject<bool>(HiveBoxes.didSeeOnboarding, value);

  bool get didSeeOnboarding =>
      store.getSingleObject<bool>(HiveBoxes.didSeeOnboarding) ?? false;

  void _setDefaults() {
    config.setDefaults(defaultConfigs);
  }

  T getValue<T extends Object>(String key) {
    switch (T) {
      case bool:
        return config.getBool(key) as T;
      case int:
        return config.getInt(key) as T;
      case double:
        return config.getDouble(key) as T;
      case String:
        return config.getString(key) as T;
      default:
        throw Exception('Unsupported type: $T');
    }
  }
}
