import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferencesService {
  final SharedPreferences _preferences;

  SharedpreferencesService(this._preferences);

  static const String _keyUser = "USER_KEY_LOGIN";
  static const String _keyLaunch = "USER_KEY_LAUNCH";

  Future<void> setStatusUser(UserLocal user) async {
    try {
      await _preferences.setBool(_keyUser, user.statusLogin);
      await _preferences.setBool(_keyLaunch, user.statusFirstLaunch);
    } catch (e) {
      throw Exception("Shared preferences cannot set data user");
    }
  }

  UserLocal getStatusUser() {
    return UserLocal(
      statusLogin: _preferences.getBool(_keyUser) ?? false,
      statusFirstLaunch: _preferences.getBool(_keyLaunch) ?? true,
    );
  }
}
