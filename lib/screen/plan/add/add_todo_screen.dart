import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/textformfield_widget.dart';
import 'package:flutter/material.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taksNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Data Task',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 70),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _PickedDate(dateController: _startDateController),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PickedDate(dateController: _endDateController),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                TextFormFieldWidget(
                  controller: _taksNameController,
                  label: "Nama Task",
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama task tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                Text(
                  "Project",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 6),
                const _CategoryWidget(),
                const SizedBox(height: 50),
                ButtonWidget(
                  key: const Key('tambah_data_button'),
                  title: "Tambah Data",
                  textColor: AppColors.btnTextWhite.colors,
                  foregroundColor: AppColors.bgSoftGreen.colors,
                  backgroundColor: AppColors.btnGreen.colors,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Data ${_taksNameController.text}, start: ${_startDateController.text}, end: ${_endDateController.text} ditambahkan',
                          ),
                        ),
                      );
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
    _taksNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
  }
}

class _PickedDate extends StatefulWidget {
  final TextEditingController dateController;
  const _PickedDate({required this.dateController});

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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tanggal tidak boleh kosong';
        }
        return null;
      },
    );
  }
}

class _CategoryWidget extends StatefulWidget {
  const _CategoryWidget({super.key});

  @override
  State<_CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<_CategoryWidget> {
  String? _selectedCategory;

  final List<String> _categories = [
    'Marketing',
    'Management',
    'Finance',
    'Development',
  ];

  void _addCategory() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _categories.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var category in _categories)
              ChoiceChip(
                label: Text(category, style: TextStyle(fontFamily: 'Inter')),
                selected: _selectedCategory == category,
                selectedColor: AppColors.bgSoftGreen.colors,
                onSelected: (_) {
                  setState(() => _selectedCategory = category);
                },
                side: BorderSide(color: AppColors.bgGreen.colors),
                labelStyle: TextStyle(
                  color: _selectedCategory == category
                      ? AppColors.bgGreen.colors
                      : AppColors.bgGreen.colors,
                ),
              ),
            ActionChip(
              backgroundColor: AppColors.bgSoftGreen.colors,
              side: BorderSide(color: Colors.transparent),
              label: Text(
                'Add Category',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppColors.btnGreen.colors,
                ),
              ),
              onPressed: _addCategory,
            ),
          ],
        ),
      ],
    );
  }
}
