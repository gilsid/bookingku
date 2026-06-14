/// Model Booking yang mendukung serialisasi JSON.
import 'package:bookingku/features/booking/domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.bookingCode,
    required super.userId,
    required super.fieldId,
    required super.fieldName,
    required super.fieldLocation,
    required super.fieldFormat,
    required super.bookingDate,
    required super.startTime,
    required super.endTime,
    required super.durationHours,
    required super.totalPrice,
    super.promoCode,
    required super.discountAmount,
    required super.status,
    super.paymentProofUrl,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as int,
      bookingCode: json['booking_code'] as String,
      userId: json['user_id'] as int,
      fieldId: json['field_id'] as int,
      fieldName: json['field_name'] as String,
      fieldLocation: json['field_location'] as String,
      fieldFormat: json['field_format'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      durationHours: json['duration_hours'] as int,
      totalPrice: json['total_price'] as int,
      promoCode: json['promo_code'] as String?,
      discountAmount: json['discount_amount'] as int,
      status: json['status'] as String,
      paymentProofUrl: json['payment_proof_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_code': bookingCode,
      'user_id': userId,
      'field_id': fieldId,
      'field_name': fieldName,
      'field_location': fieldLocation,
      'field_format': fieldFormat,
      'booking_date': bookingDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'duration_hours': durationHours,
      'total_price': totalPrice,
      'promo_code': promoCode,
      'discount_amount': discountAmount,
      'status': status,
      'payment_proof_url': paymentProofUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  BookingModel copyWith({
    String? status,
    String? paymentProofUrl,
  }) {
    return BookingModel(
      id: id,
      bookingCode: bookingCode,
      userId: userId,
      fieldId: fieldId,
      fieldName: fieldName,
      fieldLocation: fieldLocation,
      fieldFormat: fieldFormat,
      bookingDate: bookingDate,
      startTime: startTime,
      endTime: endTime,
      durationHours: durationHours,
      totalPrice: totalPrice,
      promoCode: promoCode,
      discountAmount: discountAmount,
      status: status ?? this.status,
      paymentProofUrl: paymentProofUrl ?? this.paymentProofUrl,
      createdAt: createdAt,
    );
  }
}
