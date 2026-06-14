/// Entity Akun Pembayaran (Bank / E-Wallet).
import 'package:equatable/equatable.dart';

class PaymentAccount extends Equatable {
  final int id;
  final String type; // "bank" atau "ewallet"
  final String provider; // "BCA", "Mandiri", "GoPay", "OVO", "Dana"
  final String accountNumber;
  final String accountName;
  final String? iconUrl;
  final bool isActive;

  const PaymentAccount({
    required this.id,
    required this.type,
    required this.provider,
    required this.accountNumber,
    required this.accountName,
    this.iconUrl,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, type, provider, accountNumber, accountName, iconUrl, isActive];
}
