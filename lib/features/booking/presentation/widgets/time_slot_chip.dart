/// Chip untuk memilih slot waktu pemesanan lapangan.
///
/// Menyediakan 3 state tampilan:
/// 1. Available: Border abu-abu, teks gelap (bisa diklik)
/// 2. Selected: Background navy gelap, teks putih, ikon checkmark ✓ (bisa diklik)
/// 3. Disabled: Background abu-abu terang, teks abu-abu pudar, tidak bisa diklik (sudah dibooking)
import 'package:flutter/material.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_radius.dart';

class TimeSlotChip extends StatelessWidget {
  final String time;
  final bool isAvailable;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeSlotChip({
    super.key,
    required this.time,
    required this.isAvailable,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    BorderSide borderSide;

    if (!isAvailable) {
      bgColor = AppColors.dividerGrey;
      textColor = AppColors.textHint;
      borderSide = BorderSide.none;
    } else if (isSelected) {
      bgColor = AppColors.primaryDark;
      textColor = AppColors.white;
      borderSide = BorderSide.none;
    } else {
      bgColor = AppColors.white;
      textColor = AppColors.textPrimary;
      borderSide = const BorderSide(color: AppColors.borderGrey);
    }

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.borderRadiusS,
          border: borderSide != BorderSide.none ? Border.fromBorderSide(borderSide) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, color: AppColors.white, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              time,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
