/// Entity Lapangan (Field) dan Foto Lapangan (FieldImage) untuk BookingKu.
import 'package:equatable/equatable.dart';

class FieldImage extends Equatable {
  final int id;
  final int fieldId;
  final String imageUrl;
  final bool isPrimary;

  const FieldImage({
    required this.id,
    required this.fieldId,
    required this.imageUrl,
    required this.isPrimary,
  });

  @override
  List<Object?> get props => [id, fieldId, imageUrl, isPrimary];
}

class Field extends Equatable {
  final int id;
  final String name;
  final String description;
  final String type; // e.g. "sintetis", "indoor", "outdoor"
  final String location;
  final String address;
  final int pricePerHour;
  final String format; // e.g. "5v5", "7v7"
  final List<String> facilities;
  final List<FieldImage> images;

  const Field({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.location,
    required this.address,
    required this.pricePerHour,
    required this.format,
    required this.facilities,
    required this.images,
  });

  String get primaryImageUrl {
    if (images.isEmpty) return '';
    final primary = images.firstWhere((img) => img.isPrimary, orElse: () => images.first);
    return primary.imageUrl;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        location,
        address,
        pricePerHour,
        format,
        facilities,
        images,
      ];
}
