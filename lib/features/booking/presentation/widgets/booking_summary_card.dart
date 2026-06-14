/// Widget Ringkasan Pesanan (Booking Summary Card) dengan left red border sesuai Figma.
import 'package:flutter/material.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/theme/app_radius.dart';
import 'package:bookingku/core/utils/formatters.dart';

class BookingSummaryCard extends StatelessWidget {
  final String fieldName;
  final String location;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int durationHours;
  final String format;

  const BookingSummaryCard({
    super.key,
    required this.fieldName,
    required this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.borderRadiusM,
        border: const Border(
          left: BorderSide(color: AppColors.primaryRed, width: 4),
          top: BorderSide(color: AppColors.borderGrey, width: 0.5),
          right: BorderSide(color: AppColors.borderGrey, width: 0.5),
          bottom: BorderSide(color: AppColors.borderGrey, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LAPANGAN',
            style: AppTextStyles.labelUpper.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalXS,
          Text(
            fieldName,
            style: AppTextStyles.headingSmall.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '📍 $location',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                Formatters.dateFull(date),
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                '$startTime - $endTime ($durationHours Jam)',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.sports_soccer, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                format,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
