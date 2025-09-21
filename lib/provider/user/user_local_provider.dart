import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/service/sharedpreferences_service.dart';
import 'package:flutter/material.dart';

class UserLocalProvider extends ChangeNotifier {
  final SharedpreferencesService _service;

  UserLocalProvider(this._service);

  String _message = "";
  String get message => _message;

  UserLocal? _userLocal;
  UserLocal? get userLocal => _userLocal;

  Future<void> setStatusUser(UserLocal user) async {
    try {
      await _service.setStatusUser(user);
      _userLocal = user;
      _message = "Status login ${_service.getStatusUser().statusLogin}";
    } catch (e) {
      _message = "Failed to change user status";
    }
    notifyListeners();
  }

  void getStatusUser() {
    try {
      _userLocal = _service.getStatusUser();
    } catch (e) {
      _message = "Failed to retrieve current user status";
    }
    notifyListeners();
  }
}
