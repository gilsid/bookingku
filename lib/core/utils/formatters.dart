/// Kumpulan fungsi formatter untuk memformat data tampilan.
///
/// Digunakan untuk format mata uang, tanggal, dan data lainnya.
import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// Format angka ke mata uang Rupiah.
  /// Contoh: 450000 → "Rp 450.000"
  static String currency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatCurrency(int amount) => currency(amount);
  static String formatDate(DateTime date) => dateShort(date);


  /// Format angka ke format singkat.
  /// Contoh: 250000 → "Rp 250k"
  static String currencyShort(int amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}k';
    }
    return 'Rp $amount';
  }

  /// Format DateTime ke string tanggal Indonesia.
  /// Contoh: 2023-10-15 → "15 Okt 2023"
  static String dateShort(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  /// Format DateTime ke string tanggal lengkap.
  /// Contoh: 2023-10-15 → "15 Oktober 2023"
  static String dateFull(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  /// Format DateTime ke nama hari singkat.
  /// Contoh: Monday → "SEN"
  static String dayShort(DateTime date) {
    const days = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB', 'MIN'];
    return days[date.weekday - 1];
  }

  /// Format DateTime ke nama bulan dan tahun.
  /// Contoh: 2023-10 → "Oktober 2023"
  static String monthYear(DateTime date) {
    return DateFormat('MMMM yyyy', 'id_ID').format(date);
  }

  /// Format waktu.
  /// Contoh: "19:00"
  static String time(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Format time range.
  /// Contoh: "19:00 - 21:00"
  static String timeRange(String startTime, String endTime) {
    return '$startTime - $endTime';
  }

  /// Format relative time (untuk notifikasi).
  /// Contoh: "2 JAM YANG LALU", "3 HARI YANG LALU"
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'BARU SAJA';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} MENIT YANG LALU';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} JAM YANG LALU';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} HARI YANG LALU';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} MINGGU YANG LALU';
    } else {
      return dateShort(dateTime);
    }
  }

  /// Format nomor telepon Indonesia.
  /// Contoh: "081234567890" → "+62 812 3456 7890"
  static String phoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = '62${cleaned.substring(1)}';
    }
    if (cleaned.length >= 10) {
      return '+${cleaned.substring(0, 2)} ${cleaned.substring(2, 5)} ${cleaned.substring(5, 9)} ${cleaned.substring(9)}';
    }
    return phone;
  }
}
