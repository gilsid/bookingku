/// Entity untuk Banner Promo di Beranda.
import 'package:equatable/equatable.dart';

class PromoBanner extends Equatable {
  final int id;
  final String title;
  final String description;
  final String code;
  final String? imageUrl;
  final String badgeText;

  const PromoBanner({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    this.imageUrl,
    required this.badgeText,
  });

  @override
  List<Object?> get props => [id, title, description, code, imageUrl, badgeText];
}
