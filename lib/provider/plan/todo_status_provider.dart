import 'package:flutter/material.dart';

class TodoStatusProvider extends ChangeNotifier {
  String _status = 'on progress';

  String get status => _status;

  void setStatus(String value) {
    _status = value;
    notifyListeners();
  }
}
