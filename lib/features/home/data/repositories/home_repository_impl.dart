/// Implementasi Mock HomeRepository.
import 'package:bookingku/features/home/data/models/banner_model.dart';
import 'package:bookingku/features/home/data/models/popular_schedule_model.dart';
import 'package:bookingku/features/home/domain/entities/banner.dart';
import 'package:bookingku/features/home/domain/entities/popular_schedule.dart';
import 'package:bookingku/features/home/domain/repositories/home_repository.dart';
import 'package:bookingku/shared/models/result.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<Result<List<PromoBanner>>> getPromoBanners() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success([
      BannerModel(
        id: 1,
        title: 'Diskon 20% Member Baru',
        description: 'Dapatkan potongan langsung untuk pemesanan pertama Anda.',
        code: 'NEW20',
        badgeText: '🔥 HOT DEAL',
      ),
      BannerModel(
        id: 2,
        title: 'Hemat 15% Jam Pagi',
        description: 'Main jam 08:00 - 12:00 lebih hemat setiap hari kerja.',
        code: 'MORNINGGOL',
        badgeText: '⚡ HAPPY HOUR',
      ),
      BannerModel(
        id: 3,
        title: 'Diskon 10k Akhir Pekan',
        description: 'Potongan Rp 10.000 untuk booking hari Sabtu & Minggu.',
        code: 'WEEKENDGOL',
        badgeText: '🌟 WEEKEND SPECIAL',
      ),
    ]);
  }

  @override
  Future<Result<List<PopularSchedule>>> getPopularSchedules() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success([
      PopularScheduleModel(
        id: 1,
        time: '19:00',
        fieldName: 'Lapangan A (Indoor)',
        type: 'Sintetis Premium • 5v5',
        pricePerHour: 150000,
      ),
      PopularScheduleModel(
        id: 2,
        time: '20:00',
        fieldName: 'Gelora Bung Karno Mini Soccer',
        type: 'Sintetis Premium • 7v7',
        pricePerHour: 220000,
      ),
      PopularScheduleModel(
        id: 3,
        time: '18:00',
        fieldName: 'Arena Utama A (Outdoor)',
        type: 'Rumput Alami • 5v5',
        pricePerHour: 180000,
      ),
    ]);
  }
}
