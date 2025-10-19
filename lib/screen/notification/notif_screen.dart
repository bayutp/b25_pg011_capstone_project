import 'package:b25_pg011_capstone_project/data/model/user_notification.dart';
import 'package:b25_pg011_capstone_project/provider/user/user_local_provider.dart';
import 'package:b25_pg011_capstone_project/service/firebase_firestore_service.dart';
import 'package:b25_pg011_capstone_project/static/helper.dart';
import 'package:b25_pg011_capstone_project/style/colors/app_colors.dart';
import 'package:b25_pg011_capstone_project/widget/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotifScreen extends StatefulWidget {
  const NotifScreen({super.key});

  @override
  State<NotifScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  late FirebaseFirestoreService _firestoreService;
  late UserLocalProvider _sp;
  List<UserNotification> notifications = [];

  @override
  void initState() {
    super.initState();
    _firestoreService = context.read<FirebaseFirestoreService>();
    _sp = context.read<UserLocalProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final uid = _sp.userLocal?.uid ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: StreamBuilder(
        stream: _firestoreService.getUserNotif(uid),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return Center(
              child: Text(
                Helper.errMsg,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: AppColors.textGrey.colors,
                ),
              ),
            );
          }
          final notifications = asyncSnapshot.data ?? [];

          if (notifications.isEmpty) {
            return Center(
              child: Text(
                "Belum ada data notifikasi",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: AppColors.textGrey.colors,
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final n = notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: n.isRead
                      ? Colors.grey.shade300
                      : Theme.of(context).colorScheme.primary,
                  child: Icon(
                    n.isRead ? Icons.notifications_none : Icons.notifications,
                    color: n.isRead ? Colors.black54 : Colors.white,
                  ),
                ),
                title: Text(
                  n.title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: n.isRead ? FontWeight.normal : FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  n.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontFamily: 'Inter'),
                ),
                trailing: Text(
                  Helper.formatTime(n.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: 'Inter',
                  ),
                ),
                onTap: () async {
                  // handle tap, e.g., navigate or mark as read
                  final uid = _sp.userLocal?.uid ?? '';
                  if (uid.isNotEmpty) {
                    await _firestoreService.markAsRead(uid, n.id);
                  }
                  if (context.mounted) {
                    _showDialog(context, n.title, n.body);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String notes) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detail Notification',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(notes, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
