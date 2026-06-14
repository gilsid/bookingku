/// Custom App Bar widgets matching Figma designs.
///
/// Menyediakan dua jenis AppBar:
/// 1. [BookingKuAppBar]: AppBar utama dengan logo teks "BookingKu" + ikon bola di kiri, serta ikon notifikasi di kanan.
/// 2. [BackAppBar]: AppBar untuk detail screen dengan back arrow di kiri dan judul di tengah.
import 'package:flutter/material.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';

class BookingKuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final int notificationCount;
  final Widget? leadingAction; // Opsional leading action (misalnya settings di Profile)

  const BookingKuAppBar({
    super.key,
    this.onNotificationTap,
    this.notificationCount = 0,
    this.leadingAction,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.sports_soccer,
            color: AppColors.primaryRed,
            size: 26,
          ),
          const SizedBox(width: 8),
          Text(
            'BookingKu',
            style: AppTextStyles.headingSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      centerTitle: true,
      leading: leadingAction,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.textPrimary,
                size: 26,
              ),
              onPressed: onNotificationTap,
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.unreadDot,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    notificationCount > 9 ? '9+' : '$notificationCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const BackAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
          size: 24,
        ),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: AppTextStyles.headingSmall.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
