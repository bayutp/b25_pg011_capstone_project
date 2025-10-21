import 'dart:async';

import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:flutter/widgets.dart';

class UserIncomeProvider extends ChangeNotifier {
  final FirebaseFirestoreService _firestoreService;
  final String _uid;
  final String _idbuz;


  num _userIncome = 0;
  num _userExpense = 0;

  num get userIncome => _userIncome;

  num get userExpense => _userExpense;

  num get userBalance => _userIncome - _userExpense;

  StreamSubscription? _incomeSubscription;
  StreamSubscription? _expenseSubscription;

  UserIncomeProvider(this._firestoreService, this._uid, this._idbuz) {
    _listenToCashflows();
  }

  void _listenToCashflows() {
    _incomeSubscription?.cancel();
    _expenseSubscription?.cancel();

    _incomeSubscription = _firestoreService.getTotalCashflowByType(
        _uid, _idbuz, DateTime.now(), "monthly", "income").listen((income) {
      _userIncome = income;
      notifyListeners();
    });

    _expenseSubscription = _firestoreService.getTotalCashflowByType(
        _uid, _idbuz, DateTime.now(), "monthly", "expense").listen((expense) {
      _userExpense = expense;
      notifyListeners();
    });
  }

  void updateDate(DateTime newDate) {
    _listenToCashflows();
  }

  @override
  void dispose() {
    _incomeSubscription?.cancel();
    _expenseSubscription?.cancel();
    super.dispose();
  }

  void setUserIncome(num income) {
    _userIncome = income;
    notifyListeners();
  }

  void setUserExpense(num expense) {
    _userExpense = expense;
    notifyListeners();
  }
}
