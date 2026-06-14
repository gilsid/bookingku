/// Interface repository untuk manajemen jadwal lapangan dan pemesanan.
import 'package:bookingku/features/booking/domain/entities/booking.dart';
import 'package:bookingku/features/booking/domain/entities/schedule.dart';
import 'package:bookingku/shared/models/result.dart';

abstract class BookingRepository {
  Future<Result<List<Schedule>>> getSchedules(int fieldId, DateTime date);
  Future<Result<Booking>> createBooking({
    required int fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int userId,
    String? promoCode,
  });
  Future<Result<List<Booking>>> getBookingHistory(int userId);
  Future<Result<Booking>> getBookingDetail(String bookingId);
  Future<Result<Booking>> cancelBooking(String bookingId);
  Future<Result<Booking>> uploadPaymentProof(String bookingId, String proofPath);
  Future<Result<Booking>> verifyMockPayment(String bookingId);
}
