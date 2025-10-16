import 'package:b25_pg011_capstone_project/data/model/transaction_type.dart';
import 'package:flutter/cupertino.dart';

class TransactionTypeProvider extends ChangeNotifier {
  TransactionType? _transactionType;

  TransactionType? get transactionType => _transactionType;

  void setType(TransactionType? type) {
    _transactionType = type;
    notifyListeners();
  }
}
