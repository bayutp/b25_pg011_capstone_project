import 'package:intl/intl.dart';

class Helper {
  static String errMsg = "Terjadi kesalahan.";
  static String errFmt = "Data dari server tidak valid.";
  static String errInet = "Tidak ada koneksi internet.";
  static String errServer = "Gagal terhubung ke server. Coba lagi nanti.";

  static final _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 2,
  );

  static String formatCurrency(num value) => _formatter.format(value);

  static String progressText(int finishedTask, int allTask) {
    if (allTask == 0) {
      return "0/0 Tasks - 0%";
    }

    final percent = (finishedTask / allTask) * 100;
    return "$finishedTask/$allTask Tasks - ${percent.toStringAsFixed(0)}%";
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  Map<String, DateTime> getDateRange(String period, DateTime date) {
    switch (period) {
      case 'daily':
        return {
          'start': DateTime(date.year, date.month, date.day),
          'end': DateTime(date.year, date.month, date.day, 23, 59, 59),
        };
      case 'weekly':
        final start = date.subtract(Duration(days: date.weekday - 1));
        final end = start.add(
          const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        return {'start': start, 'end': end};
      case 'monthly':
        final start = DateTime(date.year, date.month, 1);
        final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
        return {'start': start, 'end': end};
      default:
        throw Exception('Invalid period');
    }
  }
}
