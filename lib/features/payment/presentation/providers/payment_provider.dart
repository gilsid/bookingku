import 'package:flutter/material.dart';
import 'package:bookingku/features/payment/domain/entities/payment_account.dart';
import 'package:bookingku/features/payment/domain/repositories/payment_repository.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentRepository _paymentRepository;

  List<PaymentAccount> _paymentAccounts = [];
  PaymentAccount? _selectedAccount;
  bool _isLoading = false;
  String? _errorMessage;

  PaymentProvider(this._paymentRepository);

  List<PaymentAccount> get paymentAccounts => _paymentAccounts;
  PaymentAccount? get selectedAccount => _selectedAccount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPaymentAccounts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _paymentRepository.getPaymentAccounts();
    result.when(
      success: (data) {
        _paymentAccounts = data;
        // Select BCA by default if available
        if (data.isNotEmpty) {
          _selectedAccount = data.firstWhere(
            (acc) => acc.provider.contains('BCA'),
            orElse: () => data.first,
          );
        }
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

  void selectPaymentAccount(PaymentAccount account) {
    _selectedAccount = account;
    notifyListeners();
  }
}
