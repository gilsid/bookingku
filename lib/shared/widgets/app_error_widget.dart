/// Widget untuk menampilkan halaman error dengan tombol coba lagi.
///
/// Dinamai [AppErrorWidget] agar tidak bentrok dengan class ErrorWidget bawaan Flutter.
import 'package:flutter/material.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.errorRed,
            ),
            AppSpacing.verticalM,
            Text(
              'Terjadi Kesalahan',
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalS,
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalXL,
            PrimaryButton(
              text: 'Coba Lagi',
              onPressed: onRetry,
              isFullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
