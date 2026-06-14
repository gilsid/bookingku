/// Custom button widgets matching Figma designs.
///
/// Menyediakan dua varian tombol:
/// 1. [PrimaryButton]: Tombol utama merah solid.
/// 2. [CustomOutlinedButton]: Tombol dengan border merah dan latar belakang transparan/putih.
import 'package:flutter/material.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_radius.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final bool isFullWidth;
  final bool isDisabled;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 12),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: AppTextStyles.buttonText.copyWith(
            color: isDisabled ? AppColors.textHint : AppColors.white,
          ),
        ),
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? AppColors.disabledGrey : AppColors.primaryRed,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusM,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        child: buttonContent,
      ),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final bool isFullWidth;
  final bool isDisabled;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: AppColors.primaryRed,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 12),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: AppTextStyles.buttonText.copyWith(
            color: isDisabled ? AppColors.textHint : AppColors.primaryRed,
          ),
        ),
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          backgroundColor: AppColors.white,
          side: BorderSide(
            color: isDisabled ? AppColors.disabledGrey : AppColors.primaryRed,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusM,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        child: buttonContent,
      ),
    );
  }
}
