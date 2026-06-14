/// Entity untuk Jadwal Terpopuler di Beranda.
import 'package:equatable/equatable.dart';

class PopularSchedule extends Equatable {
  final int id;
  final String time;
  final String fieldName;
  final String type;
  final int pricePerHour;

  const PopularSchedule({
    required this.id,
    required this.time,
    required this.fieldName,
    required this.type,
    required this.pricePerHour,
  });

  @override
  List<Object?> get props => [id, time, fieldName, type, pricePerHour];
}
