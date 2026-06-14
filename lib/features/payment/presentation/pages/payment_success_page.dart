import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/formatters.dart';
import 'package:bookingku/features/booking/presentation/providers/booking_provider.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final booking = bookingProvider.currentBooking;

    if (booking == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Pemesanan tidak ditemukan.', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Kembali ke Beranda',
                onPressed: () => context.goNamed('home'),
              ),
            ],
          ),
        ),
      );
    }

    final formattedDate = Formatters.formatDate(booking.bookingDate);
    final totalPay = booking.totalPrice + 10000 - booking.discountAmount;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          // Header section (Dark Navy with check icon)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 70,
              bottom: 40,
              left: AppSpacing.spacingXL,
              right: AppSpacing.spacingXL,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                // Success Checkmark Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryRed,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Pembayaran Berhasil!',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Pesanan Anda telah dikonfirmasi dan jadwal lapangan telah dipesan.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Details Card
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.spacingL),
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.spacingL),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
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
                      // Field Header Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.sports_soccer,
                              color: AppColors.primaryRed,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LAPANGAN',
                                  style: AppTextStyles.labelUpper.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.borderGrey, height: 1),
                      const SizedBox(height: 20),

                      // Details rows
                      _buildDetailRow('TANGGAL & WAKTU', '$formattedDate\n${booking.startTime} - ${booking.endTime} (${booking.durationHours} Jam)'),
                      const SizedBox(height: 16),
                      _buildDetailRow('TIPE LAPANGAN', 'Sintetis Premium • ${booking.fieldFormat}'),
                      const SizedBox(height: 16),
                      _buildDetailRow('BOOKING ID', booking.bookingCode, isBookingId: true),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingL),

                // Total Summary Card
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        Formatters.formatCurrency(totalPay),
                        style: AppTextStyles.price.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingXXL),

                // Action Buttons
                PrimaryButton(
                  text: '📋 Lihat Tiket',
                  onPressed: () {
                    context.pushReplacementNamed(
                      'ticket',
                      pathParameters: {'bookingId': booking.bookingCode},
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.spacingM),
                CustomOutlinedButton(
                  text: '🏠 Kembali ke Beranda',
                  onPressed: () {
                    context.goNamed('home');
                  },
                ),
                const SizedBox(height: AppSpacing.spacingXL),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBookingId = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelUpper.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isBookingId ? AppColors.primaryRed : AppColors.textPrimary,
            fontSize: isBookingId ? 16 : 14,
            letterSpacing: isBookingId ? 0.5 : 0.0,
          ),
        ),
      ],
    );
  }
}
