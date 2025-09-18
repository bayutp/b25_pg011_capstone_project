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
}
