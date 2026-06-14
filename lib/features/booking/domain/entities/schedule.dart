/// Entity Jadwal Waktu (Schedule Slot) untuk lapangan futsal/mini soccer.
import 'package:equatable/equatable.dart';

class Schedule extends Equatable {
  final int id;
  final int fieldId;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String status; // "available", "booked", "maintenance"

  const Schedule({
    required this.id,
    required this.fieldId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  bool get isAvailable => status == 'available';

  String get timeRange => '$startTime - $endTime';

  @override
  List<Object?> get props => [id, fieldId, date, startTime, endTime, status];
}
