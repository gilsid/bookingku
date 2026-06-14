/// Model Banner yang mendukung serialisasi JSON.
import 'package:bookingku/features/home/domain/entities/banner.dart';

class BannerModel extends PromoBanner {
  const BannerModel({
    required super.id,
    required super.title,
    required super.description,
    required super.code,
    super.imageUrl,
    required super.badgeText,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      code: json['code'] as String,
      imageUrl: json['image_url'] as String?,
      badgeText: json['badge_text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'code': code,
      'image_url': imageUrl,
      'badge_text': badgeText,
    };
  }
}
