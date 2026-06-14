/// Interface repository untuk Beranda.
import 'package:bookingku/features/home/domain/entities/banner.dart';
import 'package:bookingku/features/home/domain/entities/popular_schedule.dart';
import 'package:bookingku/shared/models/result.dart';

abstract class HomeRepository {
  Future<Result<List<PromoBanner>>> getPromoBanners();
  Future<Result<List<PopularSchedule>>> getPopularSchedules();
}
