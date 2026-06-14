import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/formatters.dart';
import 'package:bookingku/features/booking/presentation/providers/booking_provider.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';
import 'package:bookingku/shared/widgets/loading_widget.dart';
import 'package:bookingku/shared/widgets/app_error_widget.dart';
import 'package:bookingku/features/auth/presentation/providers/auth_provider.dart';

class TicketPage extends StatefulWidget {
  final String bookingId;

  const TicketPage({super.key, required this.bookingId});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().fetchBookingDetail(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.currentUser?.name ?? 'Pengguna';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: BackAppBar(
        title: 'Tiket Digital',
        onBack: () {
          // If previous location was payment-success, we should pop or go back to home/history
          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed('home');
          }
        },
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          if (provider.errorMessage != null) {
            return AppErrorWidget(
              message: provider.errorMessage!,
              onRetry: () => provider.fetchBookingDetail(widget.bookingId),
            );
          }

          final booking = provider.viewingBookingDetail;
          if (booking == null) {
            return const Center(
              child: Text('Data tiket tidak ditemukan.'),
            );
          }

          final formattedDate = Formatters.formatDate(booking.bookingDate);

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingL,
              vertical: AppSpacing.spacingM,
            ),
            children: [
              // Ticket Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Section
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.spacingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  booking.fieldName,
                                  style: AppTextStyles.headingSmall.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDark.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Sintetis Premium',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 16),
                              const SizedBox(width: 8),
                              Text(formattedDate, style: AppTextStyles.bodyMedium),
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
                        ],
                      ),
                    ),

                    // Ticket Punch Line (Visual Divider)
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.scaffoldBackground,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  (constraints.constrainWidth() / 12).floor(),
                                  (index) => SizedBox(
                                    width: 6,
                                    height: 1.5,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: AppColors.borderGrey.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 16,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.scaffoldBackground,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Bottom Section (QR Code)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.spacingL),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          // QR Container
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.borderGrey),
                            ),
                            child: const Icon(
                              Icons.qr_code_2,
                              color: AppColors.primaryDark,
                              size: 140,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'BOOKING ID',
                            style: AppTextStyles.labelUpper.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking.bookingCode,
                            style: AppTextStyles.headingMedium.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryRed,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'PEMESAN',
                            style: AppTextStyles.labelUpper.copyWith(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.spacingXL),

              // Petunjuk Penggunaan Card
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
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.primaryRed, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Petunjuk Penggunaan',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.spacingM),
                    _buildInstructionRow('Tunjukkan kode QR ini kepada petugas di lokasi.'),
                    const SizedBox(height: 8),
                    _buildInstructionRow('Datang 15 menit sebelum jadwal.'),
                    const SizedBox(height: 8),
                    _buildInstructionRow('Patuhi protokol kebersihan di area lapangan.'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.spacingXXL),

              // Action Buttons
              PrimaryButton(
                text: '⬇ Simpan ke Galeri',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tiket berhasil disimpan ke Galeri!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.spacingM),
              CustomOutlinedButton(
                text: '↗ Bagikan Tiket',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tautan tiket berhasil disalin!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.spacingXL),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInstructionRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryRed)),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
