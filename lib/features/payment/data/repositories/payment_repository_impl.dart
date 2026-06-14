/// Implementasi Mock PaymentRepository.
import 'package:bookingku/features/payment/domain/entities/payment_account.dart';
import 'package:bookingku/features/payment/domain/repositories/payment_repository.dart';
import 'package:bookingku/shared/models/result.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  @override
  Future<Result<List<PaymentAccount>>> getPaymentAccounts() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Result.success([
      PaymentAccount(
        id: 1,
        type: 'ewallet',
        provider: 'GoPay',
        accountNumber: '081234567890',
        accountName: 'BookingKu Official',
        isActive: true,
      ),
      PaymentAccount(
        id: 2,
        type: 'ewallet',
        provider: 'OVO',
        accountNumber: '081234567890',
        accountName: 'BookingKu Official',
        isActive: true,
      ),
      PaymentAccount(
        id: 3,
        type: 'bank',
        provider: 'BCA Virtual Account',
        accountNumber: '8800 1234 5678',
        accountName: 'PT BookingKu Indonesia',
        isActive: true,
      ),
      PaymentAccount(
        id: 4,
        type: 'bank',
        provider: 'Mandiri Virtual Account',
        accountNumber: '8900 9876 5432',
        accountName: 'PT BookingKu Indonesia',
        isActive: true,
      ),
    ]);
  }
}
