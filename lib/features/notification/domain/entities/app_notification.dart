import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  final int id;
  final String title;
  final String body;
  final String type; // 'success', 'payment', 'promo', 'reminder'
  final DateTime createdAt;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  AppNotification copyWith({
    int? id,
    String? title,
    String? body,
    String? type,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, title, body, type, createdAt, isRead];
}
