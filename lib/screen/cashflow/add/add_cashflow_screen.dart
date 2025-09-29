import 'package:b25_pg011_capstone_project/data/model/transaction_type.dart';
import 'package:b25_pg011_capstone_project/provider/cashflow/transaction_type_provider.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../style/colors/app_colors.dart';

class AddCashflowScreen extends StatefulWidget {
  const AddCashflowScreen({super.key});

  @override
  State<AddCashflowScreen> createState() => _AddCashflowScreenState();
}

class _AddCashflowScreenState extends State<AddCashflowScreen> {
  final _formKey = GlobalKey<FormState>();

  final _expenseController = TextEditingController();

  final _dateController = TextEditingController();

  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                _PickedDate(dateController: _dateController),
                SizedBox(height: 28),
                TextFormFieldWidget(
                  controller: _expenseController,
                  label: "Total Pengeluaran",
                  obscureText: false,
                ),
                SizedBox(height: 28),
                TextFormFieldWidget(
                  controller: _noteController,
                  label: "Keterangan",
                  obscureText: false,
                ),
                SizedBox(height: 50),
                ButtonWidget(
                  title: "Tambahkan Data",
                  textColor: AppColors.btnTextWhite.colors,
                  foregroundColor: AppColors.bgSoftGreen.colors,
                  backgroundColor: AppColors.bgGreen.colors,
                  onPressed: () {},
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
}

class _TransactionType extends StatelessWidget {
  const _TransactionType({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionTypeProvider>(
      builder: (context, value, child) {
        return Row(
          children: [
            Radio<TransactionType>(
              value: TransactionType.income,
              groupValue: value.transactionType,
              onChanged: value.setType,
            ),
            Text(
              "Pemasukan",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 12),
            ),
            SizedBox(width: 8),
            Radio<TransactionType>(
              value: TransactionType.expense,
              groupValue: value.transactionType,
              onChanged: value.setType,
            ),
            Text(
              "Pengeluaran",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}

class _PickedDate extends StatefulWidget {
  final TextEditingController dateController;

  const _PickedDate({super.key, required this.dateController});

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
        widget.dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      controller: widget.dateController,
      label: "Pilih Tanggal",
      obscureText: false,
      readOnly: true,
      onTap: _selectDate,
    );
  }
}
