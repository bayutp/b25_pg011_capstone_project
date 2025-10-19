import 'package:b25_pg011_capstone_project/data/model/transaction_type.dart';
import 'package:b25_pg011_capstone_project/data/model/user_cashflow.dart';
import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/transaction_type_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/static/helper.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/snackbar_widget.dart';
import 'package:b25_pg011_capstone_project/widget/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../style/colors/app_colors.dart';

class AddCashflowScreen extends StatefulWidget {
  const AddCashflowScreen({super.key});

  @override
  State<AddCashflowScreen> createState() => _AddCashflowScreenState();
}

class _AddCashflowScreenState extends State<AddCashflowScreen> {
  final _formKey = GlobalKey<FormState>();
  final _expenseKey = GlobalKey<FormFieldState>();
  final _keyNote = GlobalKey<FormFieldState>();
  final _keyDate = GlobalKey<FormFieldState>();

  final _expenseController = TextEditingController();

  final _dateController = TextEditingController();

  final _noteController = TextEditingController();

  bool _isLoading = false;

  late UserLocal user;

  @override
  void initState() {
    super.initState();
    final provider = context.read<UserLocalProvider>();
    user = provider.userLocal!;
  }

  @override
  Widget build(BuildContext context) {
    final transactionType =
        context.watch<TransactionTypeProvider>().transactionType ==
            TransactionType.expense
        ? "Pengeluaran"
        : "Pemasukan";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Data Cash flow",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 18,
            top: 70,
            bottom: 18,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jenis",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 16,
                    color: AppColors.textBlack.colors,
                  ),
                ),
                SizedBox(height: 18),
                _TransactionType(),
                SizedBox(height: 28),
                _PickedDate(dateController: _dateController, formKey: _keyDate),
                SizedBox(height: 28),
                TextFormFieldWidget(
                  key: _expenseKey,
                  controller: _expenseController,
                  label: "Total $transactionType",
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    RupiahFormatter(),
                  ],
                  validator: (value) {
                    final numericString = toNumericString(value);
                    if (numericString.contains('-')) {
                      return 'Tidak boleh angka negatif';
                    }
                    if (numericString.isEmpty ||
                        double.tryParse(numericString) == 0.0) {
                      return 'Total $transactionType harus lebih dari 0';
                    }
                    return null;
                  },
                  onChange: (value) => _expenseKey.currentState?.validate(),
                ),
                SizedBox(height: 28),
                TextFormFieldWidget(
                  key: _keyNote,
                  controller: _noteController,
                  label: "Keterangan",
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Keterangan tidak boleh kosong';
                    }
                    return null;
                  },
                  onChange: (value) => _keyNote.currentState?.validate(),
                ),
                SizedBox(height: 50),
                ButtonWidget(
                  title: "Tambahkan Data",
                  isLoading: _isLoading,
                  textColor: AppColors.btnTextWhite.colors,
                  foregroundColor: AppColors.bgSoftGreen.colors,
                  backgroundColor: AppColors.bgGreen.colors,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveCashflow();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dateController.dispose();
    _expenseController.dispose();
    _noteController.dispose();
  }

  Future<void> _saveCashflow() async {
    final service = context.read<FirebaseFirestoreService>();
    final typeProvider = context.read<TransactionTypeProvider>();
    final type = typeProvider.transactionType == TransactionType.income
        ? "income"
        : "expense";
    final dateParts = _dateController.text.split('/');
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);
    final now = DateTime.now();
    final date = DateTime(year, month, day, now.hour, now.minute, now.second);
    final amount =
        double.tryParse(toNumericString(_expenseController.text)) ?? 0.0;
    final note = _noteController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      await service.addCashflow(
        UserCashflow(
          businessId: user.idbuz,
          userId: user.uid,
          amount: amount,
          type: type,
          note: note,
          date: date,
          createdBy: user.uid,
          createdAt: DateTime.now(),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackbarWidget(
            message: "Data Berhasil disimpan",
            success: true,
            icon: Icons.check_circle_rounded,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackbarWidget(
            message: "Data Gagal disimpan",
            success: false,
            icon: Icons.cancel_rounded,
          ),
        );
      }
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _TransactionType extends StatelessWidget {
  const _TransactionType();

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionTypeProvider>(
      builder: (context, value, child) {
        return FormField<TransactionType>(
          validator: (value) {
            if (value == null) {
              return 'Jenis transaksi harus dipilih';
            }
            return null;
          },
          builder: (formKey) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioGroup<TransactionType>(
                  groupValue: value.transactionType,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<TransactionTypeProvider>().setType(value);
                      formKey.didChange(value);
                      formKey.validate();
                    }
                  },
                  child: Row(
                    children: [
                      Radio<TransactionType>(value: TransactionType.income),
                      Text(
                        "Pemasukan",
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 12),
                      ),
                      SizedBox(width: 8),
                      Radio<TransactionType>(value: TransactionType.expense),
                      Text(
                        "Pengeluaran",
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (formKey.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                    child: Text(
                      formKey.errorText ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PickedDate extends StatefulWidget {
  final TextEditingController dateController;
  final GlobalKey<FormFieldState> formKey;

  const _PickedDate({required this.dateController, required this.formKey});

  @override
  State<_PickedDate> createState() => _PickedDateState();
}

class _PickedDateState extends State<_PickedDate> {
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("id", "ID"),
    );

    if (picked != null) {
      setState(() {
        widget.dateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
      widget.formKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      key: widget.formKey,
      controller: widget.dateController,
      label: "Pilih Tanggal",
      obscureText: false,
      readOnly: true,
      onTap: _selectDate,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tanggal tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
