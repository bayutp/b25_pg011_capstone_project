import 'package:flutter/material.dart';

class DetailStatusProvider extends ChangeNotifier {
  String _status = 'on progress';

  String get status => _status;

  void setStatus(String value) {
    _status = value;
    notifyListeners();
  }
}
