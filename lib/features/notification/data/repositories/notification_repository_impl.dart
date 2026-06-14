import 'package:bookingku/features/notification/domain/entities/app_notification.dart';
import 'package:bookingku/features/notification/domain/repositories/notification_repository.dart';
import 'package:bookingku/shared/models/result.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  static final List<AppNotification> _notificationsDb = [
    AppNotification(
      id: 1,
      title: 'Booking Berhasil!',
      body: 'Pemesanan Gelora Bung Karno Mini Soccer telah berhasil dikonfirmasi.',
      type: 'success',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      id: 2,
      title: 'Segera Selesaikan Pembayaran',
      body: 'Selesaikan pembayaran sebesar Rp 450.000 untuk Booking ID BKU-7729103.',
      type: 'payment',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: false,
    ),
    AppNotification(
      id: 3,
      title: 'Promo Akhir Pekan!',
      body: 'Gunakan kode promo WEEKENDGOL untuk mendapatkan potongan harga Rp 10.000.',
      type: 'promo',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    AppNotification(
      id: 4,
      title: 'Terima kasih telah bermain!',
      body: 'Terima kasih telah menggunakan BookingKu. Berikan ulasan untuk membantu kami meningkatkan layanan.',
      type: 'reminder',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
  ];

  @override
  Future<Result<List<AppNotification>>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Result.success(List.from(_notificationsDb));
  }

  @override
  Future<Result<void>> markAsRead(int notificationId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _notificationsDb.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notificationsDb[index] = _notificationsDb[index].copyWith(isRead: true);
    }
    return Result.success(null);
  }

  @override
  Future<Result<void>> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (int i = 0; i < _notificationsDb.length; i++) {
      _notificationsDb[i] = _notificationsDb[i].copyWith(isRead: true);
    }
    return Result.success(null);
  }
}
