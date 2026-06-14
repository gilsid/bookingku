import 'package:bookingku/features/notification/domain/entities/app_notification.dart';
import 'package:bookingku/shared/models/result.dart';

abstract class NotificationRepository {
  Future<Result<List<AppNotification>>> getNotifications();
  Future<Result<void>> markAsRead(int notificationId);
  Future<Result<void>> markAllAsRead();
}
