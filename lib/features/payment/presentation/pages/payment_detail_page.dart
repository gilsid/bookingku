import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/formatters.dart';
import 'package:bookingku/features/booking/presentation/providers/booking_provider.dart';
import 'package:bookingku/features/payment/presentation/providers/payment_provider.dart';
import 'package:bookingku/features/payment/presentation/widgets/payment_method_tile.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';
import 'package:bookingku/shared/widgets/loading_widget.dart';
import 'package:bookingku/shared/widgets/app_error_widget.dart';

class PaymentDetailPage extends StatefulWidget {
  const PaymentDetailPage({super.key});

  @override
  State<PaymentDetailPage> createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchPaymentAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final booking = bookingProvider.currentBooking;

    if (booking == null) {
      return Scaffold(
        appBar: const BackAppBar(title: 'Detail Pembayaran'),
        body: Center(
          child: Text(
            'Tidak ada pemesanan aktif.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    final rentPrice = booking.totalPrice;
    const serviceFee = 10000;
    final promoDiscount = booking.discountAmount;
    final totalPay = rentPrice + serviceFee - promoDiscount;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: BackAppBar(
        title: 'Detail Pembayaran',
        onBack: () => context.pop(),
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, paymentProvider, child) {
          if (paymentProvider.isLoading) {
            return const LoadingWidget();
          }

          if (paymentProvider.errorMessage != null) {
            return AppErrorWidget(
              message: paymentProvider.errorMessage!,
              onRetry: () => paymentProvider.fetchPaymentAccounts(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.spacingL),
            children: [
              // Total Banner (Navy Card)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingXL,
                  vertical: AppSpacing.spacingXXL,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.bannerGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'TOTAL YANG HARUS DIBAYAR',
                      style: AppTextStyles.labelUpper.copyWith(
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatters.formatCurrency(totalPay),
                      style: AppTextStyles.headingLarge.copyWith(
                        color: AppColors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.spacingL),

              // Ringkasan Pesanan Card (Red left border)
              _buildOrderSummaryCard(booking),
              const SizedBox(height: AppSpacing.spacingXL),

              // Metode Pembayaran Header
              Row(
                children: [
                  const Icon(Icons.payment, color: AppColors.primaryRed, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Pilih Metode Pembayaran',
                    style: AppTextStyles.headingSmall.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingM),

              // E-Wallet Section
              if (paymentProvider.paymentAccounts.any((a) => a.type == 'ewallet')) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    'E-WALLET',
                    style: AppTextStyles.labelUpper.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...paymentProvider.paymentAccounts
                    .where((a) => a.type == 'ewallet')
                    .map((acc) => PaymentMethodTile(
                          account: acc,
                          isSelected: paymentProvider.selectedAccount == acc,
                          onTap: () => paymentProvider.selectPaymentAccount(acc),
                        )),
                const SizedBox(height: AppSpacing.spacingM),
              ],

              // Virtual Account Section
              if (paymentProvider.paymentAccounts.any((a) => a.type == 'bank')) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                  child: Text(
                    'VIRTUAL ACCOUNT',
                    style: AppTextStyles.labelUpper.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...paymentProvider.paymentAccounts
                    .where((a) => a.type == 'bank')
                    .map((acc) => PaymentMethodTile(
                          account: acc,
                          isSelected: paymentProvider.selectedAccount == acc,
                          onTap: () => paymentProvider.selectPaymentAccount(acc),
                        )),
                const SizedBox(height: AppSpacing.spacingM),
              ],

              const SizedBox(height: AppSpacing.spacingS),

              // Rincian Pembayaran
              Container(
                padding: const EdgeInsets.all(AppSpacing.spacingL),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rincian Pembayaran',
                      style: AppTextStyles.headingSmall.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacingM),
                    _buildPricingRow('Harga Sewa', rentPrice),
                    const SizedBox(height: AppSpacing.spacingS),
                    _buildPricingRow('Biaya Layanan', serviceFee),
                    if (promoDiscount > 0) ...[
                      const SizedBox(height: AppSpacing.spacingS),
                      _buildPricingRow('Diskon Promo', -promoDiscount, isDiscount: true),
                    ],
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Divider(color: AppColors.borderGrey, height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Bayar',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          Formatters.formatCurrency(totalPay),
                          style: AppTextStyles.price.copyWith(
                            fontSize: 18,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.spacingXXL),

              // Action Button
              CustomButton(
                text: 'Bayar Sekarang →',
                onPressed: () {
                  if (paymentProvider.selectedAccount == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pilih metode pembayaran terlebih dahulu'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  context.pushNamed('upload-proof');
                },
              ),
              const SizedBox(height: AppSpacing.spacingXL),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderSummaryCard(dynamic booking) {
    final formattedDate = Formatters.formatDate(booking.bookingDate);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppColors.primaryRed,
                width: 6,
              ),
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LAPANGAN',
                style: AppTextStyles.labelUpper.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                booking.fieldName,
                style: AppTextStyles.headingSmall.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.spacingM),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${booking.startTime} - ${booking.endTime} (${booking.durationHours} Jam)',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.sports_soccer, color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Sintetis Premium • ${booking.fieldFormat}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingRow(String label, int value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium,
        ),
        Text(
          isDiscount
              ? '- ${Formatters.formatCurrency(value.abs())}'
              : Formatters.formatCurrency(value),
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.successGreen : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
