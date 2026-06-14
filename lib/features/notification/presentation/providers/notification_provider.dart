import 'package:flutter/material.dart';
import 'package:bookingku/features/notification/domain/entities/app_notification.dart';
import 'package:bookingku/features/notification/domain/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _notificationRepository;

  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  NotificationProvider(this._notificationRepository);

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _notificationRepository.getNotifications();
    result.when(
      success: (data) {
        _notifications = data;
        _isLoading = false;
        notifyListeners();
      },
      failure: (msg) {
        _errorMessage = msg;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> markAsRead(int notificationId) async {
    final result = await _notificationRepository.markAsRead(notificationId);
    result.when(
      success: (_) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
          notifyListeners();
        }
      },
      failure: (_) {},
    );
  }

  Future<void> markAllAsRead() async {
    final result = await _notificationRepository.markAllAsRead();
    result.when(
      success: (_) {
        for (int i = 0; i < _notifications.length; i++) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
        }
        notifyListeners();
      },
      failure: (_) {},
    );
  }
}
