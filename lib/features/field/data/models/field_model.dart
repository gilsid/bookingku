/// Model Field dan FieldImage dengan serialisasi JSON.
import 'package:bookingku/features/field/domain/entities/field.dart';

class FieldImageModel extends FieldImage {
  const FieldImageModel({
    required super.id,
    required super.fieldId,
    required super.imageUrl,
    required super.isPrimary,
  });

  factory FieldImageModel.fromJson(Map<String, dynamic> json) {
    return FieldImageModel(
      id: json['id'] as int,
      fieldId: json['field_id'] as int,
      imageUrl: json['image_url'] as String,
      isPrimary: json['is_primary'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_id': fieldId,
      'image_url': imageUrl,
      'is_primary': isPrimary,
    };
  }
}

class FieldModel extends Field {
  const FieldModel({
    required super.id,
    required super.name,
    required super.description,
    required super.type,
    required super.location,
    required super.address,
    required super.pricePerHour,
    required super.format,
    required super.facilities,
    required super.images,
  });

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    final imagesList = (json['images'] as List<dynamic>?)
            ?.map((img) => FieldImageModel.fromJson(img as Map<String, dynamic>))
            .toList() ??
        [];

    return FieldModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      pricePerHour: json['price_per_hour'] as int,
      format: json['format'] as String,
      facilities: List<String>.from(json['facilities'] as List<dynamic>),
      images: imagesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'location': location,
      'address': address,
      'price_per_hour': pricePerHour,
      'format': format,
      'facilities': facilities,
      'images': images.map((img) => (img as FieldImageModel).toJson()).toList(),
    };
  }
}
