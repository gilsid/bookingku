/// Badge status dalam bentuk kapsul kecil (pill) untuk menandai status pemesanan.
///
/// Menyediakan warna latar belakang dan teks yang sesuai dengan status:
/// - Menunggu Pembayaran
/// - Menunggu Verifikasi
/// - Dikonfirmasi
/// - Selesai
/// - Dibatalkan
/// - Ditolak
import 'package:flutter/material.dart';
import 'package:bookingku/core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const StatusBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  /// Factory untuk membuat badge berdasarkan status string (dari BookingStatus enum).
  factory StatusBadge.fromStatus(String status) {
    String label;
    Color bg;
    Color textCol;

    switch (status.toLowerCase()) {
      case 'pending':
      case 'menunggu pembayaran':
        label = 'Menunggu Pembayaran';
        bg = AppColors.primaryRed.withOpacity(0.1);
        textCol = AppColors.primaryRed;
        break;
      case 'waitingverification':
      case 'menunggu verifikasi':
        label = 'Menunggu Verifikasi';
        bg = AppColors.warningOrange.withOpacity(0.1);
        textCol = AppColors.warningOrange;
        break;
      case 'confirmed':
      case 'dikonfirmasi':
        label = 'Dikonfirmasi';
        bg = Colors.blue.withOpacity(0.1);
        textCol = Colors.blue.shade700;
        break;
      case 'completed':
      case 'selesai':
        label = 'Selesai';
        bg = AppColors.successGreen.withOpacity(0.1);
        textCol = AppColors.successGreen;
        break;
      case 'cancelled':
      case 'dibatalkan':
        label = 'Dibatalkan';
        bg = AppColors.disabledGrey.withOpacity(0.2);
        textCol = AppColors.textSecondary;
        break;
      case 'rejected':
      case 'ditolak':
        label = 'Ditolak';
        bg = AppColors.errorRed.withOpacity(0.1);
        textCol = AppColors.errorRed;
        break;
      default:
        label = status;
        bg = AppColors.disabledGrey.withOpacity(0.2);
        textCol = AppColors.textSecondary;
    }

    return StatusBadge(
      text: label,
      backgroundColor: bg,
      textColor: textCol,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
