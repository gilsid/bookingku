/// HomeProvider untuk memuat data banner dan jadwal terpopuler di Beranda.
import 'package:flutter/material.dart';
import 'package:bookingku/features/home/domain/entities/banner.dart';
import 'package:bookingku/features/home/domain/entities/popular_schedule.dart';
import 'package:bookingku/features/home/domain/repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _homeRepository;

  List<PromoBanner> _banners = [];
  List<PopularSchedule> _popularSchedules = [];
  bool _isLoading = false;
  String? _errorMessage;

  HomeProvider(this._homeRepository);

  List<PromoBanner> get banners => _banners;
  List<PopularSchedule> get popularSchedules => _popularSchedules;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Memuat semua data untuk halaman beranda secara paralel.
  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final results = await Future.wait([
      _homeRepository.getPromoBanners(),
      _homeRepository.getPopularSchedules(),
    ]);

    final bannersResult = results[0];
    final schedulesResult = results[1];

    bannersResult.when(
      success: (data) => _banners = data as List<PromoBanner>,
      failure: (msg) => _errorMessage = msg,
    );

    schedulesResult.when(
      success: (data) => _popularSchedules = data as List<PopularSchedule>,
      failure: (msg) => _errorMessage = msg,
    );

    _isLoading = false;
    notifyListeners();
  }
}
