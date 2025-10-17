import 'package:b25_pg011_capstone_project/data/model/user_local.dart';
import 'package:b25_pg011_capstone_project/data/model/user_plan.dart';
import 'package:b25_pg011_capstone_project/data/model/user_todo.dart';
import 'package:b25_pg011_capstone_project/provider/plan/user_plan_provider.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/button_widget.dart';
import 'package:b25_pg011_capstone_project/widget/snackbar_widget.dart';
import 'package:b25_pg011_capstone_project/widget/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatefulWidget {
  final UserLocal user;
  const AddTodoScreen({super.key, required this.user});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();

  late UserPlanProvider? userPlanProvider;
  late UserLocalProvider sp;
  final TextEditingController _taksNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        userPlanProvider = context.read<UserPlanProvider>();
      }
    });
  }

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
                      child: _PickedDate(
                        dateController: _startDateController,
                        label: "Mulai",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PickedDate(
                        dateController: _endDateController,
                        label: "Selesai",
                      ),
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
                _CategoryWidget(
                  key: ValueKey("fieldCategory"),
                  user: widget.user,
                ),
                const SizedBox(height: 50),
                ButtonWidget(
                  key: const Key('tambah_data_button'),
                  title: "Tambah Data",
                  isLoading: isLoading,
                  textColor: AppColors.btnTextWhite.colors,
                  foregroundColor: AppColors.bgSoftGreen.colors,
                  backgroundColor: AppColors.btnGreen.colors,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    final selectedPlan = userPlanProvider?.selectedPlan;

                    // Cek dulu apakah plan sudah dipilih
                    if (selectedPlan == null || selectedPlan.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackbarWidget(
                          message: 'Silahkan pilih project terlebih dahulu',
                          success: false,
                        ),
                      );
                      return;
                    }

                    try {
                      final startParts = _startDateController.text.split('/');
                      final endParts = _endDateController.text.split('/');

                      if (startParts.length < 3 || endParts.length < 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackbarWidget(
                            message: 'Format tanggal tidak valid',
                            success: false,
                          ),
                        );
                        return;
                      }

                      final startDate = DateTime(
                        int.parse(startParts[2]),
                        int.parse(startParts[1]),
                        int.parse(startParts[0]),
                      );

                      final endDate = DateTime(
                        int.parse(endParts[2]),
                        int.parse(endParts[1]),
                        int.parse(endParts[0]),
                      );

                      if (startDate.isAfter(endDate)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackbarWidget(
                            message:
                                "Tanggal selesai tidak boleh kurang dari tanggal mulai",
                            success: false,
                          ),
                        );
                        return;
                      }
                      _addTodo(widget.user);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackbarWidget(
                          message: 'Terjadi kesalahan saat memproses tanggal',
                          success: false,
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

  void _addTodo(UserLocal user) async {
    final service = context.read<FirebaseFirestoreService>();
    final planId = userPlanProvider?.idPlan ?? '';
    final plan = userPlanProvider?.selectedPlan ?? '';
    final todoName = _taksNameController.text;

    final startDateParts = _startDateController.text.split('/');
    final endDateParts = _endDateController.text.split('/');

    final now = DateTime.now();

    final startDate = DateTime(
      int.parse(startDateParts[2]),
      int.parse(startDateParts[1]),
      int.parse(startDateParts[0]),
      now.hour,
      now.minute,
      now.second,
    );

    final endDate = DateTime(
      int.parse(endDateParts[2]),
      int.parse(endDateParts[1]),
      int.parse(endDateParts[0]),
      now.hour,
      now.minute,
      now.second,
    );

    final userId = user.uid;
    final businessId = user.idbuz;
    final createdBy = user.uid;
    final createdAt = DateTime.now();
    final status = "on progress";

    setState(() {
      isLoading = true;
    });

    try {
      final newTodo = UserTodo(
        planId: planId,
        userId: userId,
        businessId: businessId,
        todo: todoName,
        plan: plan,
        startDate: startDate,
        endDate: endDate,
        status: status,
        createdBy: createdBy,
        createdAt: createdAt,
      );
      await service.addTodo(newTodo);
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
            message: 'Gagal menambahkan task',
            success: false,
            icon: Icons.cancel_rounded,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

class _PickedDate extends StatefulWidget {
  final TextEditingController dateController;
  final String label;
  const _PickedDate({required this.dateController, required this.label});

  @override
  State<_PickedDate> createState() => _PickedDateState();
}

class _PickedDateState extends State<_PickedDate> {
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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
      label: "Tanggal ${widget.label}",
      obscureText: false,
      readOnly: true,
      onTap: _selectDate,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Tanggal ${widget.label} tidak boleh kosong';
        }
        return null;
      },
    );
  }
}

class _CategoryWidget extends StatefulWidget {
  final UserLocal user;
  const _CategoryWidget({super.key, required this.user});

  @override
  State<_CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<_CategoryWidget> {
  late UserPlanProvider userPlanProvider;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        userPlanProvider = context.read<UserPlanProvider>();
        userPlanProvider.setSelectedPlan("");
      }
    });
  }

  void _addCategory() async {
    final controller = TextEditingController();
    final keyForm = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Tambah Kategori',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
        ),
        content: Form(
          key: keyForm,
          child: TextFormFieldWidget(
            controller: controller,
            label: 'Nama Kategori',
            obscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama kategori tidak boleh kosong';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () => {
              if (keyForm.currentState!.validate())
                {Navigator.pop(context, controller.text)},
            },
            child: Text('Add', style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );

    void saveCategory(String category) async {
      final service = context.read<FirebaseFirestoreService>();

      try {
        final newPlan = await service.addPlan(
          UserPlan(
            businessId: widget.user.idbuz,
            userId: widget.user.uid,
            name: category,
            createdBy: widget.user.uid,
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
          userPlanProvider.setIdPlan(newPlan);
          userPlanProvider.setSelectedPlan(category);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackbarWidget(
              message: 'Gagal menambahkan kategori',
              success: false,
              icon: Icons.cancel_rounded,
            ),
          );
        }
      }
    }

    if (result != null && result.isNotEmpty) {
      saveCategory(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserPlan>>(
      create: (context) => context
          .read<FirebaseFirestoreService>()
          .getPlansByUserId(widget.user.uid, widget.user.idbuz),
      initialData: [],
      catchError: (context, error) {
        return <UserPlan>[];
      },
      builder: (context, child) {
        final categories = context.watch<List<UserPlan>>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<UserPlanProvider>(
              builder: (context, userPlanProvider, child) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var category in categories)
                      ChoiceChip(
                        label: Text(
                          category.name,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected:
                            userPlanProvider.selectedPlan == category.name,
                        selectedColor: AppColors.bgSoftGreen.colors,
                        onSelected: (_) {
                          userPlanProvider.setIdPlan(category.planId);
                          userPlanProvider.setSelectedPlan(category.name);
                        },
                        side: BorderSide(color: AppColors.bgGreen.colors),
                        labelStyle: TextStyle(
                          color: userPlanProvider.selectedPlan == category.name
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
                          fontWeight: FontWeight.w600,
                          color: AppColors.btnGreen.colors,
                        ),
                      ),
                      onPressed: _addCategory,
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
