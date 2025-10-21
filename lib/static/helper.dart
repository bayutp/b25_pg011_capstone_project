import 'package:flutter/services.dart';
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

  static String formatDate(DateTime date, {bool withTime = false}) {
    final formatDate = withTime ? 'dd MMMM yyyy, HH:mm:ss' : 'dd MMMM yyyy';
    return DateFormat(formatDate).format(date);
  }

  Map<String, DateTime> getDateRange(String period, DateTime date) {
    switch (period) {
      case 'daily':
        return {
          'start': DateTime(date.year, date.month, date.day, 00, 00, 00),
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

  static String formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

class RupiahFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return newValue.copyWith(text: '');

    final number = int.parse(digitsOnly);
    final formatted = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);

    int cursorPosition =
        formatted.length -
        (oldValue.text.length - oldValue.selection.baseOffset);

    if (cursorPosition > formatted.length) {
      cursorPosition = formatted.length;
    } else if (cursorPosition < 0) {
      cursorPosition = 0;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

String toNumericString(String? value) {
  if (value == null || value.isEmpty) return '';
  return value.replaceAll(RegExp(r'[^0-9]'), '');
}
