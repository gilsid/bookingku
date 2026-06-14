/// Implementasi Mock BookingRepository.
///
/// Menyimpan data pemesanan di memori untuk mensimulasikan database.
import 'dart:math';
import 'package:bookingku/features/booking/data/models/booking_model.dart';
import 'package:bookingku/features/booking/data/models/schedule_model.dart';
import 'package:bookingku/features/booking/domain/entities/booking.dart';
import 'package:bookingku/features/booking/domain/entities/schedule.dart';
import 'package:bookingku/features/booking/domain/repositories/booking_repository.dart';
import 'package:bookingku/shared/models/result.dart';

class BookingRepositoryImpl implements BookingRepository {
  // In-memory list untuk simulasi database pemesanan
  static final List<BookingModel> _bookingsDb = [
    BookingModel(
      id: 101,
      bookingCode: 'BKU-7729103',
      userId: 1,
      fieldId: 1,
      fieldName: 'Gelora Bung Karno Mini Soccer',
      fieldLocation: 'Jakarta Pusat',
      fieldFormat: '7v7',
      bookingDate: DateTime.now().subtract(const Duration(days: 1)),
      startTime: '19:00',
      endTime: '21:00',
      durationHours: 2,
      totalPrice: 440000,
      discountAmount: 0,
      status: 'pending', // Menunggu Pembayaran
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    BookingModel(
      id: 102,
      bookingCode: 'BKU-3829102',
      userId: 1,
      fieldId: 3,
      fieldName: 'Arena Futsal B (Indoor)',
      fieldLocation: 'Jakarta Selatan',
      fieldFormat: '5v5',
      bookingDate: DateTime.now().subtract(const Duration(days: 4)),
      startTime: '16:00',
      endTime: '18:00',
      durationHours: 2,
      totalPrice: 300000,
      discountAmount: 0,
      status: 'completed', // Selesai
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    BookingModel(
      id: 103,
      bookingCode: 'BKU-1129109',
      userId: 1,
      fieldId: 2,
      fieldName: 'Arena Utama A (Outdoor)',
      fieldLocation: 'Jakarta Selatan',
      fieldFormat: '5v5',
      bookingDate: DateTime.now().subtract(const Duration(days: 8)),
      startTime: '15:00',
      endTime: '17:00',
      durationHours: 2,
      totalPrice: 500000,
      discountAmount: 100000,
      promoCode: 'NEW20',
      status: 'cancelled', // Dibatalkan
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
  ];

  @override
  Future<Result<List<Schedule>>> getSchedules(int fieldId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Membuat slot jadwal statis dari 08:00 sampai 22:00
    final List<ScheduleModel> slots = [];
    final List<String> times = [
      '08:00', '09:00', '10:00', '11:00', '12:00', '13:00',
      '14:00', '15:00', '16:00', '17:00', '18:00', '19:00',
      '20:00', '21:00', '22:00'
    ];

    // Gunakan random berbasiskan tanggal + fieldId agar konsisten saat dibuka ulang
    final randomSeed = date.year * 10000 + date.month * 100 + date.day + fieldId;
    final rand = Random(randomSeed);

    for (int i = 0; i < times.length - 1; i++) {
      final start = times[i];
      final end = times[i + 1];

      // Acak status slot: 0 = booked, 1 = maintenance, sisanya available
      final roll = rand.nextInt(5);
      String status = 'available';
      if (roll == 0) status = 'booked';
      if (roll == 1 && i == 4) status = 'maintenance'; // Slot jam 12-13 istirahat/maintenance

      slots.add(ScheduleModel(
        id: fieldId * 100 + i,
        fieldId: fieldId,
        date: date,
        startTime: start,
        endTime: end,
        status: status,
      ));
    }

    return Result.success(slots);
  }

  @override
  Future<Result<Booking>> createBooking({
    required int fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int userId,
    String? promoCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Cari detail lapangan
    String fieldName = 'Lapangan Sewa';
    String fieldLoc = 'Jakarta';
    String fieldFmt = '5v5';
    int price = 150000;

    if (fieldId == 1) {
      fieldName = 'Gelora Bung Karno Mini Soccer';
      fieldLoc = 'Jakarta Pusat';
      fieldFmt = '7v7';
      price = 220000;
    } else if (fieldId == 2) {
      fieldName = 'Arena Utama A (Outdoor)';
      fieldLoc = 'Jakarta Selatan';
      fieldFmt = '5v5';
      price = 250000;
    } else if (fieldId == 3) {
      fieldName = 'Arena Futsal B (Indoor)';
      fieldLoc = 'Jakarta Selatan';
      fieldFmt = '5v5';
      price = 150000;
    } else if (fieldId == 4) {
      fieldName = 'Homeground Mini Soccer Cikarang';
      fieldLoc = 'Cikarang, Bekasi';
      fieldFmt = '5v5';
      price = 200000;
    }

    // Hitung durasi jam
    int startHour = int.parse(startTime.split(':')[0]);
    int endHour = int.parse(endTime.split(':')[0]);
    int duration = endHour - startHour;
    if (duration <= 0) duration = 1;

    int totalPrice = price * duration;
    int discount = 0;

    if (promoCode != null) {
      if (promoCode.toUpperCase() == 'NEW20') {
        discount = (totalPrice * 0.2).floor(); // 20% discount
      } else if (promoCode.toUpperCase() == 'MORNINGGOL') {
        discount = (totalPrice * 0.15).floor(); // 15% discount
      } else if (promoCode.toUpperCase() == 'WEEKENDGOL') {
        discount = 10000; // Rp 10.000 discount
      }
    }

    // Generate booking code
    final codeRandom = Random().nextInt(9000000) + 1000000;
    final bookingCode = 'BKU-$codeRandom';

    final newBooking = BookingModel(
      id: _bookingsDb.length + 201,
      bookingCode: bookingCode,
      userId: userId,
      fieldId: fieldId,
      fieldName: fieldName,
      fieldLocation: fieldLoc,
      fieldFormat: fieldFmt,
      bookingDate: date,
      startTime: startTime,
      endTime: endTime,
      durationHours: duration,
      totalPrice: totalPrice,
      discountAmount: discount,
      promoCode: promoCode,
      status: 'pending', // Awalnya pending (menunggu pembayaran)
      createdAt: DateTime.now(),
    );

    _bookingsDb.add(newBooking);
    return Result.success(newBooking);
  }

  @override
  Future<Result<List<Booking>>> getBookingHistory(int userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final userBookings = _bookingsDb.where((b) => b.userId == userId).toList();
    // Urutkan dari yang terbaru dibuat
    userBookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Result.success(userBookings);
  }

  @override
  Future<Result<Booking>> getBookingDetail(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final booking = _bookingsDb.firstWhere((b) => b.bookingCode == bookingId);
      return Result.success(booking);
    } catch (e) {
      return Result.failure('Pemesanan tidak ditemukan');
    }
  }

  @override
  Future<Result<Booking>> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _bookingsDb.indexWhere((b) => b.bookingCode == bookingId);
    if (index != -1) {
      final updated = _bookingsDb[index].copyWith(status: 'cancelled');
      _bookingsDb[index] = updated;
      return Result.success(updated);
    }
    return Result.failure('Pemesanan tidak ditemukan');
  }

  @override
  Future<Result<Booking>> uploadPaymentProof(String bookingId, String proofPath) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final index = _bookingsDb.indexWhere((b) => b.bookingCode == bookingId);
    if (index != -1) {
      final updated = _bookingsDb[index].copyWith(
        status: 'waitingVerification',
        paymentProofUrl: proofPath,
      );
      _bookingsDb[index] = updated;
      return Result.success(updated);
    }
    return Result.failure('Pemesanan tidak ditemukan');
  }

  @override
  Future<Result<Booking>> verifyMockPayment(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _bookingsDb.indexWhere((b) => b.bookingCode == bookingId);
    if (index != -1) {
      final updated = _bookingsDb[index].copyWith(status: 'confirmed');
      _bookingsDb[index] = updated;
      return Result.success(updated);
    }
    return Result.failure('Pemesanan tidak ditemukan');
  }
}
