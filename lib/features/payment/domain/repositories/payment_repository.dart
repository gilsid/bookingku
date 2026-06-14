/// Interface repository untuk metode pembayaran.
import 'package:bookingku/features/payment/domain/entities/payment_account.dart';
import 'package:bookingku/shared/models/result.dart';

abstract class PaymentRepository {
  Future<Result<List<PaymentAccount>>> getPaymentAccounts();
}
