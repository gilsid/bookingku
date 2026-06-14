/// Model Schedule yang mendukung serialisasi JSON.
import 'package:bookingku/features/booking/domain/entities/schedule.dart';

class ScheduleModel extends Schedule {
  const ScheduleModel({
    required super.id,
    required super.fieldId,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.status,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as int,
      fieldId: json['field_id'] as int,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_id': fieldId,
      'date': date.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
    };
  }

  ScheduleModel copyWith({
    String? status,
  }) {
    return ScheduleModel(
      id: id,
      fieldId: fieldId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      status: status ?? this.status,
    );
  }
}
