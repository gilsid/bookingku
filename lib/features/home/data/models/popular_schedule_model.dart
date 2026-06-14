/// Model PopularSchedule yang mendukung serialisasi JSON.
import 'package:bookingku/features/home/domain/entities/popular_schedule.dart';

class PopularScheduleModel extends PopularSchedule {
  const PopularScheduleModel({
    required super.id,
    required super.time,
    required super.fieldName,
    required super.type,
    required super.pricePerHour,
  });

  factory PopularScheduleModel.fromJson(Map<String, dynamic> json) {
    return PopularScheduleModel(
      id: json['id'] as int,
      time: json['time'] as String,
      fieldName: json['field_name'] as String,
      type: json['type'] as String,
      pricePerHour: json['price_per_hour'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'field_name': fieldName,
      'type': type,
      'price_per_hour': pricePerHour,
    };
  }
}
