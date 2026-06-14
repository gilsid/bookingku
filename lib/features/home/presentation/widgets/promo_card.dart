/// Widget Promo Card untuk menampilkan info diskon/promo di beranda.
import 'package:flutter/material.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/theme/app_radius.dart';
import 'package:bookingku/features/home/domain/entities/banner.dart';

class PromoCard extends StatelessWidget {
  final PromoBanner banner;
  final VoidCallback? onTap;

  const PromoCard({
    super.key,
    required this.banner,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.borderRadiusL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed.withOpacity(0.1),
                      borderRadius: AppRadius.borderRadiusS,
                    ),
                    child: Text(
                      banner.badgeText,
                      style: AppTextStyles.labelUpper.copyWith(
                        color: AppColors.primaryRed,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AppSpacing.verticalM,
                  // Title
                  Text(
                    banner.title,
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.verticalXS,
                  // Description
                  Text(
                    banner.description,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              AppSpacing.verticalM,
              // Promo Code Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.dividerGrey,
                  borderRadius: AppRadius.borderRadiusS,
                  border: Border.all(
                    color: AppColors.borderGrey,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'KODE: ${banner.code}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const Icon(
                      Icons.copy,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
