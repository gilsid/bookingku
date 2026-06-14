import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/formatters.dart';
import 'package:bookingku/features/auth/presentation/providers/auth_provider.dart';
import 'package:bookingku/features/booking/presentation/providers/booking_provider.dart';
import 'package:bookingku/features/booking/domain/entities/booking.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/empty_state_widget.dart';
import 'package:bookingku/shared/widgets/loading_widget.dart';
import 'package:bookingku/shared/widgets/app_error_widget.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _activeFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Menunggu', 'Selesai', 'Dibatalkan'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });
  }

  void _loadHistory() {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.id ?? 0;
    context.read<BookingProvider>().fetchHistory(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: BookingKuAppBar(
        onNotificationTap: () => context.pushNamed('notification'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.spacingL, AppSpacing.spacingL, AppSpacing.spacingL, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat',
                  style: AppTextStyles.headingLarge.copyWith(
                    fontSize: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lacak semua pesanan lapangan Anda.',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),

          // Filters row
          const SizedBox(height: AppSpacing.spacingL),
          _buildFilterTabs(),
          const SizedBox(height: AppSpacing.spacingM),

          // List content
          Expanded(
            child: Consumer<BookingProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const LoadingWidget();
                }

                if (provider.errorMessage != null) {
                  return AppErrorWidget(
                    message: provider.errorMessage!,
                    onRetry: _loadHistory,
                  );
                }

                final bookings = _getFilteredBookings(provider.bookingHistory);

                if (bookings.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.history_outlined,
                    title: 'Belum Ada Transaksi',
                    description: 'Transaksi pemesanan lapangan Anda akan tercatat di sini.',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingL),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _buildHistoryCard(context, provider, booking);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingL),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isActive = _activeFilter == filter;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                filter,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive ? AppColors.white : AppColors.textSecondary,
                ),
              ),
              selected: isActive,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _activeFilter = filter;
                  });
                }
              },
              selectedColor: AppColors.primaryDark,
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isActive ? Colors.transparent : AppColors.borderGrey,
                ),
              ),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          );
        },
      ),
    );
  }

  List<Booking> _getFilteredBookings(List<Booking> allBookings) {
    if (_activeFilter == 'Semua') {
      return allBookings;
    } else if (_activeFilter == 'Menunggu') {
      return allBookings
          .where((b) => b.status == 'pending' || b.status == 'waitingVerification')
          .toList();
    } else if (_activeFilter == 'Selesai') {
      return allBookings
          .where((b) => b.status == 'completed' || b.status == 'confirmed')
          .toList();
    } else {
      // Dibatalkan
      return allBookings.where((b) => b.status == 'cancelled').toList();
    }
  }

  Widget _buildHistoryCard(
    BuildContext context,
    BookingProvider provider,
    Booking booking,
  ) {
    final formattedDate = Formatters.formatDate(booking.bookingDate);

    // Status styling
    String statusText;
    Color statusColor;
    bool hasLeftBorder = false;

    switch (booking.status) {
      case 'pending':
        statusText = 'Menunggu Pembayaran';
        statusColor = AppColors.warningOrange;
        hasLeftBorder = true;
        break;
      case 'waitingVerification':
        statusText = 'Menunggu Verifikasi';
        statusColor = AppColors.warningOrange;
        break;
      case 'confirmed':
      case 'completed':
        statusText = 'Selesai';
        statusColor = AppColors.successGreen;
        break;
      case 'cancelled':
      default:
        statusText = 'Dibatalkan';
        statusColor = AppColors.textSecondary;
        break;
    }

    final totalPay = booking.totalPrice + 10000 - booking.discountAmount;
    final isCancelled = booking.status == 'cancelled';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingM),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: hasLeftBorder
                ? const Border(
                    left: BorderSide(
                      color: AppColors.primaryRed,
                      width: 5,
                    ),
                  )
                : null,
          ),
          padding: const EdgeInsets.all(AppSpacing.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card (Status Badge + Date)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingM),

              // Title
              Text(
                booking.fieldName,
                style: AppTextStyles.headingSmall.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: isCancelled ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 8),

              // Booking Details
              Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    '${booking.startTime} - ${booking.endTime} (${booking.durationHours} Jam)',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.sports_soccer, color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    booking.fieldFormat,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingM),
              const Divider(color: AppColors.dividerGrey, height: 1),
              const SizedBox(height: AppSpacing.spacingM),

              // Bottom card (Price + Action Button)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Bayar',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Formatters.formatCurrency(totalPay),
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isCancelled ? AppColors.textSecondary : AppColors.primaryRed,
                          decoration: isCancelled ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                  _buildActionButton(context, provider, booking),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    BookingProvider provider,
    Booking booking,
  ) {
    if (booking.status == 'pending') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
        ),
        onPressed: () {
          provider.setCurrentBooking(booking);
          context.pushNamed('payment-detail');
        },
        child: Text(
          'Bayar Sekarang',
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      );
    } else if (booking.status == 'confirmed' || booking.status == 'completed') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryDark),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () {
              context.pushNamed(
                'ticket',
                pathParameters: {'bookingId': booking.bookingCode},
              );
            },
            child: Text(
              'Lihat Tiket',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryRed),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () {
              context.goNamed('booking');
            },
            child: Text(
              'Pesan Lagi',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ],
      );
    } else {
      // Dibatalkan / Lainnya
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryRed),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: () {
          context.goNamed('booking');
        },
        child: Text(
          'Pesan Lagi',
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryRed,
          ),
        ),
      );
    }
  }
}
