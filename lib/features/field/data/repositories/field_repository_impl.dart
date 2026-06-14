/// Implementasi Mock FieldRepository.
import 'package:bookingku/features/field/data/models/field_model.dart';
import 'package:bookingku/features/field/domain/entities/field.dart';
import 'package:bookingku/features/field/domain/repositories/field_repository.dart';
import 'package:bookingku/shared/models/result.dart';

class FieldRepositoryImpl implements FieldRepository {
  final List<FieldModel> _mockFields = [
    const FieldModel(
      id: 1,
      name: 'Gelora Bung Karno Mini Soccer',
      description: 'Lapangan mini soccer berstandar internasional dengan rumput sintetis premium kualitas terbaik dari Italia. Dilengkapi dengan tribun penonton yang nyaman dan pencahayaan lampu LED yang terang untuk bermain malam hari.',
      type: 'sintetis',
      location: 'Jakarta Pusat',
      address: 'Kawasan Gelora Bung Karno, Jl. Pintu Satu Senayan, Jakpus',
      pricePerHour: 220000,
      format: '7v7',
      facilities: ['Rumput Sintetis Premium', 'Kamar Ganti & Shower', 'Wi-Fi Gratis', 'Locker Room', 'Parkir Luas', 'Lampu LED Malam'],
      images: [
        FieldImageModel(id: 1, fieldId: 1, imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=600', isPrimary: true),
        FieldImageModel(id: 2, fieldId: 1, imageUrl: 'https://images.unsplash.com/photo-1529900748604-07564a03e7a6?q=80&w=600', isPrimary: false),
      ],
    ),
    const FieldModel(
      id: 2,
      name: 'Arena Utama A (Outdoor)',
      description: 'Lapangan outdoor 5v5 dengan rumput alami pilihan yang dirawat secara rutin. Sangat cocok untuk pertandingan santai bersama teman-teman kantor dengan hembusan angin segar sore hari.',
      type: 'outdoor',
      location: 'Jakarta Selatan',
      address: 'Jl. Kemang Raya No. 45, Jakarta Selatan',
      pricePerHour: 250000,
      format: '5v5',
      facilities: ['Rumput Alami', 'Kamar Mandi', 'Kantin', 'Parkir Motor/Mobil'],
      images: [
        FieldImageModel(id: 3, fieldId: 2, imageUrl: 'https://images.unsplash.com/photo-1431324155629-1a6edd1d222a?q=80&w=600', isPrimary: true),
      ],
    ),
    const FieldModel(
      id: 3,
      name: 'Arena Futsal B (Indoor)',
      description: 'Lapangan indoor serbaguna yang menggunakan lantai interlock berstandar nasional. Bebas dari cuaca hujan dan panas matahari, memberikan kenyamanan maksimal saat bermain futsal.',
      type: 'indoor',
      location: 'Jakarta Selatan',
      address: 'Jl. Fatmawati Raya No. 10, Jakarta Selatan',
      pricePerHour: 150000,
      format: '5v5',
      facilities: ['Lantai Interlock', 'Kipas Angin Besar', 'Kamar Mandi', 'Locker', 'Kantin'],
      images: [
        FieldImageModel(id: 4, fieldId: 3, imageUrl: 'https://images.unsplash.com/photo-1577223625856-4545d191844e?q=80&w=600', isPrimary: true),
      ],
    ),
    const FieldModel(
      id: 4,
      name: 'Homeground Mini Soccer Cikarang',
      description: 'Pusat mini soccer modern di kawasan industri Cikarang. Menyajikan lapangan sintetis premium 5v5 dengan fasilitas pendukung lengkap untuk komunitas sepak bola.',
      type: 'sintetis',
      location: 'Cikarang, Bekasi',
      address: 'Kawasan Lippo Cikarang, Jl. Mohammad Husni Thamrin, Bekasi',
      pricePerHour: 200000,
      format: '5v5',
      facilities: ['Rumput Sintetis', 'Shower Air Hangat', 'Tribun Penonton', 'Mushola', 'Kantin & Cafe'],
      images: [
        FieldImageModel(id: 5, fieldId: 4, imageUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?q=80&w=600', isPrimary: true),
      ],
    ),
  ];

  @override
  Future<Result<List<Field>>> getFields() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_mockFields);
  }

  @override
  Future<Result<Field>> getFieldDetail(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final field = _mockFields.firstWhere(
      (f) => f.id == id,
      orElse: () => _mockFields.first,
    );
    return Result.success(field);
  }
}
