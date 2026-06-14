/// Halaman Konfirmasi Booking / Rincian Harga Pemesanan.
///
/// Tempat pengguna meninjau jadwal, memasukkan kode promo, dan
/// melihat rincian biaya sebelum lanjut ke pembayaran.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_radius.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/formatters.dart';
import 'package:bookingku/features/booking/presentation/providers/booking_provider.dart';
import 'package:bookingku/features/booking/presentation/widgets/booking_summary_card.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';

class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({super.key});

  @override
  State<BookingConfirmationPage> createState() => _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  final _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo(BookingProvider bookingProv) {
    if (_promoController.text.trim().isEmpty) return;

    // Ambil harga per jam (sebenarnya bisa dihitung dari totalPrice / duration)
    final booking = bookingProv.currentBooking;
    if (booking == null) return;

    final pricePerHour = (booking.totalPrice / booking.durationHours).round();
    final result = bookingProv.applyPromo(_promoController.text, pricePerHour);

    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kode promo berhasil diterapkan!'),
            backgroundColor: AppColors.successGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      failure: (msg) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  void _removePromo(BookingProvider bookingProv) {
    bookingProv.applyPromo('', 0);
    _promoController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kode promo dihapus'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToPayment(BookingProvider bookingProv) {
    final booking = bookingProv.currentBooking;
    if (booking == null) return;

    // Perbarui booking dengan promo yang telah diterapkan di provider
    if (bookingProv.appliedPromoCode != null) {
      final updatedBooking = (booking as dynamic).copyWith(
        promoCode: bookingProv.appliedPromoCode,
        discountAmount: bookingProv.promoDiscount,
      );
      bookingProv.setCurrentBooking(updatedBooking);
    }

    context.pushNamed('payment-detail');
  }

  @override
  Widget build(BuildContext context) {
    final bookingProv = context.watch<BookingProvider>();
    final booking = bookingProv.currentBooking;

    if (booking == null) {
      return const Scaffold(
        appBar: BackAppBar(title: 'Konfirmasi Pesanan'),
        body: Center(child: Text('Data pesanan tidak tersedia')),
      );
    }

    // Hitung rincian biaya
    const serviceFee = 10000;
    final int rentPrice = booking.totalPrice;
    final int discount = bookingProv.promoDiscount;
    final int grandTotal = rentPrice - discount + serviceFee;

    return Scaffold(
      appBar: const BackAppBar(title: 'Konfirmasi Pesanan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order details summary card
            BookingSummaryCard(
              fieldName: booking.fieldName,
              location: booking.fieldLocation,
              date: booking.bookingDate,
              startTime: booking.startTime,
              endTime: booking.endTime,
              durationHours: booking.durationHours,
              format: booking.fieldFormat,
            ),
            const SizedBox(height: 24),

            // Promo Code Input
            Text(
              'PROMO SPESIAL',
              style: AppTextStyles.labelUpper.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.verticalS,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    enabled: bookingProv.appliedPromoCode == null,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode promo (e.g. NEW20)',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      fillColor: bookingProv.appliedPromoCode != null ? AppColors.dividerGrey : Colors.transparent,
                      filled: bookingProv.appliedPromoCode != null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 52,
                  child: bookingProv.appliedPromoCode == null
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.borderRadiusM,
                            ),
                          ),
                          onPressed: () => _applyPromo(bookingProv),
                          child: const Text('Pakai'),
                        )
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.errorRed,
                            side: const BorderSide(color: AppColors.errorRed),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.borderRadiusM,
                            ),
                          ),
                          onPressed: () => _removePromo(bookingProv),
                          child: const Text('Hapus'),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Pricing details breakdown
            Text(
              'RINCIAN PEMBAYARAN',
              style: AppTextStyles.labelUpper.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.verticalM,
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderRadiusM,
                side: const BorderSide(color: AppColors.borderGrey, width: 0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPriceRow('Harga Sewa (${booking.durationHours} Jam)', Formatters.currency(rentPrice)),
                    if (discount > 0) ...[
                      AppSpacing.verticalS,
                      _buildPriceRow(
                        'Potongan Promo (${bookingProv.appliedPromoCode})',
                        '- ${Formatters.currency(discount)}',
                        isNegative: true,
                      ),
                    ],
                    AppSpacing.verticalS,
                    _buildPriceRow('Biaya Layanan', Formatters.currency(serviceFee)),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Bayar',
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Formatters.currency(grandTotal),
                          style: AppTextStyles.price.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: PrimaryButton(
            text: 'Lanjut ke Pembayaran →',
            onPressed: () => _navigateToPayment(bookingProv),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isNegative = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isNegative ? AppColors.successGreen : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
