import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/model/user_cashflow.dart';
import '../../service/firebase_firestore_service.dart';

class CashflowProvider extends ChangeNotifier {
  final FirebaseFirestoreService _firestore;
  final String _uid;
  final String _idbuz;

  List<UserCashflow> _cashflows = [];
  int _cashflowCount = 0;

  List<UserCashflow> get cashflows => _cashflows;
  int get cashflowCount => _cashflowCount;

  StreamSubscription? _cashflowListSub;
  StreamSubscription? _cashflowCountSub;

  CashflowProvider(this._firestore, this._uid, this._idbuz);

  void listenCashflow(DateTime date) {
    _cashflowListSub?.cancel();
    _cashflowCountSub?.cancel();

    _cashflowListSub = _firestore
        .getCashflowsByDate(_uid, _idbuz, date, "daily")
        .listen((data) {
          _cashflows = data;
          notifyListeners();
        });

    _cashflowCountSub = _firestore
        .getCountCashflow(_uid, _idbuz, date, "daily")
        .listen((count) {
          _cashflowCount = count;
          notifyListeners();
        });
  }

  @override
  void dispose() {
    _cashflowListSub?.cancel();
    _cashflowCountSub?.cancel();
    super.dispose();
  }
}
