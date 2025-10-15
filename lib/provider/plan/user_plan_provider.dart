import 'package:flutter/material.dart';

class UserPlanProvider extends ChangeNotifier {
  String? _selectedPlan;
  String? _idPlan;

  String? get selectedPlan => _selectedPlan;
  String? get idPlan => _idPlan;

  void setSelectedPlan(String plan) {
    _selectedPlan = plan;
    notifyListeners();
  }

  void setIdPlan(String id) {
    _idPlan = id;
    notifyListeners();
  }
}