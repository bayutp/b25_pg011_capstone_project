import 'package:flutter/material.dart';

class BottomnavProvider extends ChangeNotifier {
  int _index = 0;

  int get getIndex => _index;

  set setIndex(int value) {
    _index = value;
    notifyListeners();
  }
}
