/// Entity Pemesanan (Booking) Lapangan untuk BookingKu.
import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final int id;
  final String bookingCode;
  final int userId;
  final int fieldId;
  final String fieldName;
  final String fieldLocation;
  final String fieldFormat;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final int durationHours;
  final int totalPrice;
  final String? promoCode;
  final int discountAmount;
  final String status; // pending, waitingVerification, confirmed, completed, cancelled, rejected
  final String? paymentProofUrl;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.bookingCode,
    required this.userId,
    required this.fieldId,
    required this.fieldName,
    required this.fieldLocation,
    required this.fieldFormat,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.totalPrice,
    this.promoCode,
    required this.discountAmount,
    required this.status,
    this.paymentProofUrl,
    required this.createdAt,
  });

  int get netAmountToPay => totalPrice - discountAmount + 10000; // Includes 10k service fee from Figma

  @override
  List<Object?> get props => [
        id,
        bookingCode,
        userId,
        fieldId,
        fieldName,
        fieldLocation,
        fieldFormat,
        bookingDate,
        startTime,
        endTime,
        durationHours,
        totalPrice,
        promoCode,
        discountAmount,
        status,
        paymentProofUrl,
        createdAt,
      ];
}
