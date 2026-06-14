/// Widget untuk menampilkan state kosong.
///
/// Digunakan jika riwayat pesanan, notifikasi, atau daftar pencarian kosong.
import 'package:flutter/material.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            AppSpacing.verticalL,
            Text(
              title,
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalS,
            Text(
              description,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              AppSpacing.verticalXXL,
              PrimaryButton(
                text: actionText!,
                onPressed: onAction!,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
