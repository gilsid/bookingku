/// Entity User untuk menyimpan data pengguna BookingKu.
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, name, email, phone, profileImageUrl];
}
