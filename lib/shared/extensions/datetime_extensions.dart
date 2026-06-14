/// Extension methods pada DateTime.
import 'package:bookingku/core/utils/formatters.dart';

extension DateTimeExtensions on DateTime {
  /// Format ke tanggal singkat: "15 Okt 2023"
  String get toShortDate => Formatters.dateShort(this);

  /// Format ke tanggal lengkap: "15 Oktober 2023"
  String get toFullDate => Formatters.dateFull(this);

  /// Format ke hari singkat: "SEN"
  String get toDayShort => Formatters.dayShort(this);

  /// Format ke bulan tahun: "Oktober 2023"
  String get toMonthYear => Formatters.monthYear(this);

  /// Format ke waktu: "19:00"
  String get toTime => Formatters.time(this);

  /// Format ke waktu relatif: "2 JAM YANG LALU"
  String get toRelativeTime => Formatters.relativeTime(this);

  /// Cek apakah tanggal ini sama dengan tanggal lain (tanpa waktu).
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Cek apakah tanggal ini hari ini.
  bool get isToday => isSameDay(DateTime.now());

  /// Cek apakah tanggal ini sudah lewat.
  bool get isPast => isBefore(DateTime.now());
}
