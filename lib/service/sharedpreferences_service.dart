import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferencesService {
  final SharedPreferences _preferences;

  SharedpreferencesService(this._preferences);

  static const String _keyUser = "USER_KEY_LOGIN";
  static const String _keyLaunch = "USER_KEY_LAUNCH";
  static const String _keyUid = "USER_KEY_UID";
  static const String _keyIdbuz = "USER_KEY_IDBUZ";
  static const String _keyName = "USER_KEY_NAME";

  Future<void> setStatusUser(UserLocal user) async {
    try {
      await _preferences.setBool(_keyUser, user.statusLogin);
      await _preferences.setBool(_keyLaunch, user.statusFirstLaunch);
      await _preferences.setString(_keyUid, user.uid);
      await _preferences.setString(_keyIdbuz, user.idbuz);
      await _preferences.setString(_keyName, user.fullname);
    } catch (e) {
      throw Exception("Shared preferences cannot set data user");
    }
  }

  UserLocal getStatusUser() {
    return UserLocal(
      statusLogin: _preferences.getBool(_keyUser) ?? false,
      statusFirstLaunch: _preferences.getBool(_keyLaunch) ?? true,
      uid: _preferences.getString(_keyUid) ?? '',
      idbuz: _preferences.getString(_keyIdbuz) ?? '',
      fullname: _preferences.getString(_keyName) ?? '',
    );
  }
}
