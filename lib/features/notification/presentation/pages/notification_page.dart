import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/features/notification/presentation/providers/notification_provider.dart';
import 'package:bookingku/features/notification/domain/entities/app_notification.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/empty_state_widget.dart';
import 'package:bookingku/shared/widgets/loading_widget.dart';
import 'package:bookingku/shared/widgets/app_error_widget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: BackAppBar(
        title: 'Notifikasi',
        onBack: () => context.pop(),
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationProvider>().markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua notifikasi telah ditandai sebagai dibaca'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(
              'Baca Semua',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          if (provider.errorMessage != null) {
            return AppErrorWidget(
              message: provider.errorMessage!,
              onRetry: () => provider.fetchNotifications(),
            );
          }

          if (provider.notifications.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.notifications_off_outlined,
              title: 'Belum Ada Notifikasi',
              description: 'Kami akan memberi tahu Anda di sini ketika ada update aktivitas.',
            );
          }

          // Group notifications
          final now = DateTime.now();
          final todayNotifications = <AppNotification>[];
          final weekNotifications = <AppNotification>[];

          for (final n in provider.notifications) {
            final difference = now.difference(n.createdAt).inDays;
            if (difference < 1) {
              todayNotifications.add(n);
            } else {
              weekNotifications.add(n);
            }
          }

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingL,
              vertical: AppSpacing.spacingM,
            ),
            children: [
              if (todayNotifications.isNotEmpty) ...[
                _buildHeaderSection('HARI INI'),
                const SizedBox(height: AppSpacing.spacingS),
                ...todayNotifications.map((n) => _buildNotificationCard(context, provider, n)),
                const SizedBox(height: AppSpacing.spacingL),
              ],
              if (weekNotifications.isNotEmpty) ...[
                _buildHeaderSection('MINGGU INI'),
                const SizedBox(height: AppSpacing.spacingS),
                ...weekNotifications.map((n) => _buildNotificationCard(context, provider, n)),
              ],
            ],
          );
        },
      ),
    );
  }

    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: AppTextStyles.labelUpper.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationProvider provider,
    AppNotification notification,
  ) {
    IconData iconData;
    Color iconColor;
    Color bgCircleColor;

    switch (notification.type) {
      case 'success':
        iconData = Icons.check_circle_outline;
        iconColor = AppColors.successGreen;
        bgCircleColor = AppColors.successGreen.withOpacity(0.12);
        break;
      case 'payment':
        iconData = Icons.receipt_long;
        iconColor = AppColors.primaryRed;
        bgCircleColor = AppColors.primaryRed.withOpacity(0.12);
        break;
      case 'promo':
        iconData = Icons.local_offer_outlined;
        iconColor = AppColors.warningOrange;
        bgCircleColor = AppColors.warningOrange.withOpacity(0.12);
        break;
      case 'reminder':
      default:
        iconData = Icons.access_time;
        iconColor = AppColors.primaryDark;
        bgCircleColor = AppColors.primaryDark.withOpacity(0.12);
        break;
    }

    final timeString = _formatTimeAgo(notification.createdAt);

    return InkWell(
      onTap: () {
        if (!notification.isRead) {
          provider.markAsRead(notification.id);
        }
        
        // Handle navigation depending on types if necessary
        if (notification.type == 'payment') {
          // e.g. navigate to history/booking details
          context.pushNamed('history');
        } else if (notification.type == 'success') {
          // e.g. navigate to history
          context.pushNamed('history');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.spacingM),
        padding: const EdgeInsets.all(AppSpacing.spacingM),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgCircleColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.spacingM),
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: notification.isRead ? AppColors.textPrimary.withOpacity(0.7) : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 4, left: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.unreadDot,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeString.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }
}
