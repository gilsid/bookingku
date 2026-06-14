/// BookingProvider untuk mengelola proses pencarian jadwal, pemilihan slot,
/// pembuatan booking, promo, riwayat, dan upload bukti pembayaran.
import 'package:flutter/material.dart';
import 'package:bookingku/features/booking/domain/entities/booking.dart';
import 'package:bookingku/features/booking/domain/entities/schedule.dart';
import 'package:bookingku/features/booking/domain/repositories/booking_repository.dart';
import 'package:bookingku/shared/models/result.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _bookingRepository;

  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 12)); // Default ke hari ini/besok
  List<Schedule> _schedules = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Pemilihan Slot
  int? _selectedFieldId;
  String? _selectedStartTime;
  String? _selectedEndTime;

  // Promo
  String? _appliedPromoCode;
  int _promoDiscount = 0;

  // Booking Aktif / Detail
  Booking? _currentBooking;
  List<Booking> _bookingHistory = [];
  Booking? _viewingBookingDetail;

  BookingProvider(this._bookingRepository);

  DateTime get selectedDate => _selectedDate;
  List<Schedule> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int? get selectedFieldId => _selectedFieldId;
  String? get selectedStartTime => _selectedStartTime;
  String? get selectedEndTime => _selectedEndTime;

  String? get appliedPromoCode => _appliedPromoCode;
  int get promoDiscount => _promoDiscount;

  Booking? get currentBooking => _currentBooking;
  List<Booking> get bookingHistory => _bookingHistory;
  Booking? get viewingBookingDetail => _viewingBookingDetail;

  /// Ubah tanggal pencarian dan muat ulang jadwal.
  void changeDate(DateTime date, int fieldId) {
    _selectedDate = date;
    resetSelection();
    fetchSchedules(fieldId);
  }

  /// Memuat jadwal lapangan untuk tanggal terpilih.
  Future<void> fetchSchedules(int fieldId) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedFieldId = fieldId;
    notifyListeners();

    final result = await _bookingRepository.getSchedules(fieldId, _selectedDate);

    result.when(
      success: (data) {
        _schedules = data;
        _isLoading = false;
        notifyListeners();
      },
      failure: (msg) {
        _errorMessage = msg;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Memilih slot waktu.
  void selectSlot(String startTime, String endTime) {
    if (_selectedStartTime == startTime) {
      // Unselect jika ditekan kembali
      _selectedStartTime = null;
      _selectedEndTime = null;
    } else {
      _selectedStartTime = startTime;
      _selectedEndTime = endTime;
    }
    notifyListeners();
  }

  /// Cek apakah slot tertentu terpilih.
  bool isSlotSelected(String startTime) {
    return _selectedStartTime == startTime;
  }

  /// Mereset pilihan slot dan promo.
  void resetSelection() {
    _selectedStartTime = null;
    _selectedEndTime = null;
    _appliedPromoCode = null;
    _promoDiscount = 0;
    notifyListeners();
  }

  /// Menerapkan kode promo.
  Result<void> applyPromo(String code, int pricePerHour) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      _appliedPromoCode = null;
      _promoDiscount = 0;
      notifyListeners();
      return Result.success(null);
    }

    // Hitung total durasi
    if (_selectedStartTime == null || _selectedEndTime == null) {
      return Result.failure('Pilih slot waktu terlebih dahulu');
    }

    int startHour = int.parse(_selectedStartTime!.split(':')[0]);
    int endHour = int.parse(_selectedEndTime!.split(':')[0]);
    int duration = endHour - startHour;
    int totalPrice = pricePerHour * duration;

    if (cleanCode == 'NEW20') {
      _appliedPromoCode = 'NEW20';
      _promoDiscount = (totalPrice * 0.2).floor();
      notifyListeners();
      return Result.success(null);
    } else if (cleanCode == 'MORNINGGOL') {
      _appliedPromoCode = 'MORNINGGOL';
      _promoDiscount = (totalPrice * 0.15).floor();
      notifyListeners();
      return Result.success(null);
    } else if (cleanCode == 'WEEKENDGOL') {
      _appliedPromoCode = 'WEEKENDGOL';
      _promoDiscount = 10000;
      notifyListeners();
      return Result.success(null);
    } else {
      return Result.failure('Kode promo tidak valid');
    }
  }

  /// Membuat pesanan lapangan baru.
  Future<Result<Booking>> createBooking(int userId) async {
    if (_selectedFieldId == null || _selectedStartTime == null || _selectedEndTime == null) {
      return Result.failure('Pilihan jadwal belum lengkap');
    }

    _isLoading = true;
    notifyListeners();

    final result = await _bookingRepository.createBooking(
      fieldId: _selectedFieldId!,
      date: _selectedDate,
      startTime: _selectedStartTime!,
      endTime: _selectedEndTime!,
      userId: userId,
      promoCode: _appliedPromoCode,
    );

    result.when(
      success: (booking) {
        _currentBooking = booking;
        _isLoading = false;
        notifyListeners();
      },
      failure: (msg) {
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Memuat riwayat pemesanan pengguna.
  Future<void> fetchHistory(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _bookingRepository.getBookingHistory(userId);

    result.when(
      success: (data) {
        _bookingHistory = data;
        _isLoading = false;
        notifyListeners();
      },
      failure: (msg) {
        _errorMessage = msg;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Memuat detail pemesanan berdasarkan kode booking.
  Future<Result<Booking>> fetchBookingDetail(String bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _bookingRepository.getBookingDetail(bookingId);

    result.when(
      success: (data) {
        _viewingBookingDetail = data;
        _isLoading = false;
        notifyListeners();
      },
      failure: (msg) {
        _errorMessage = msg;
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Membatalkan pemesanan.
  Future<Result<Booking>> cancelBooking(String bookingId, int userId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _bookingRepository.cancelBooking(bookingId);

    result.when(
      success: (booking) {
        _viewingBookingDetail = booking;
        _isLoading = false;
        // Segarkan riwayat
        fetchHistory(userId);
      },
      failure: (msg) {
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Mengunggah bukti pembayaran.
  Future<Result<Booking>> uploadProof(String bookingId, String proofPath, int userId) async {
    _isLoading = true;
    notifyListeners();

    final result = await _bookingRepository.uploadPaymentProof(bookingId, proofPath);

    result.when(
      success: (booking) {
        _currentBooking = booking;
        _viewingBookingDetail = booking;
        _isLoading = false;
        // Segarkan riwayat
        fetchHistory(userId);
      },
      failure: (msg) {
        _isLoading = false;
        notifyListeners();
      },
    );

    return result;
  }

  /// Menyetujui pembayaran secara instan (untuk kelancaran demo/mocking).
  Future<void> autoVerifyPayment(String bookingId, int userId) async {
    await _bookingRepository.verifyMockPayment(bookingId);
    await fetchHistory(userId);
    if (_viewingBookingDetail?.bookingCode == bookingId) {
      await fetchBookingDetail(bookingId);
    }
  }

  /// Set booking yang sedang aktif (misalnya untuk navigasi kembali ke detail pembayaran)
  void setCurrentBooking(Booking booking) {
    _currentBooking = booking;
    notifyListeners();
  }
}
