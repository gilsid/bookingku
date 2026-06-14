/// Halaman Booking (Cari Lapangan).
///
/// Halaman tab kedua bottom navigation:
/// - Pencarian jadwal berdasarkan tanggal
/// - List lapangan beserta info harga dan time slots
/// - Tombol meluncurkan proses checkout
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_radius.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/formatters.dart';
import 'package:bookingku/features/auth/presentation/providers/auth_provider.dart';
import 'package:bookingku/features/field/presentation/providers/field_provider.dart';
import 'package:bookingku/features/booking/presentation/providers/booking_provider.dart';
import 'package:bookingku/features/booking/presentation/widgets/date_picker_horizontal.dart';
import 'package:bookingku/features/booking/presentation/widgets/time_slot_chip.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';
import 'package:bookingku/shared/widgets/loading_widget.dart';
import 'package:bookingku/shared/widgets/app_error_widget.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FieldProvider>().fetchFields();
    });
  }

  Future<void> _handleProceedToConfirmation(int fieldId) async {
    final bookingProvider = context.read<BookingProvider>();
    final authProvider = context.read<AuthProvider>();

    if (authProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu untuk membuat pesanan'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.goNamed('login');
      return;
    }

    final result = await bookingProvider.createBooking(authProvider.currentUser!.id);

    result.when(
      success: (booking) {
        if (mounted) {
          context.pushNamed('booking-confirmation');
        }
      },
      failure: (msg) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: AppColors.errorRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldProvider = context.watch<FieldProvider>();
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: const BookingKuAppBar(notificationCount: 2),
      body: LoadingOverlay(
        isLoading: bookingProvider.isLoading,
        message: 'Menyiapkan pesanan...',
        child: Column(
          children: [
            // Calendar Header (Fixed at top)
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cari Lapangan',
                    style: AppTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih jadwal dan lapangan untuk pertandingan Anda berikutnya.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  DatePickerHorizontal(
                    selectedDate: bookingProvider.selectedDate,
                    onDateSelected: (date) {
                      if (fieldProvider.fields.isNotEmpty) {
                        // Secara default muat jadwal untuk lapangan pertama
                        bookingProvider.changeDate(
                          date,
                          bookingProvider.selectedFieldId ?? fieldProvider.fields.first.id,
                        );
                      } else {
                        bookingProvider.changeDate(date, 1);
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Fields List with Time Slots
            Expanded(
              child: fieldProvider.isLoading
                  ? const LoadingWidget(message: 'Memuat lapangan...')
                  : fieldProvider.errorMessage != null
                      ? AppErrorWidget(
                          message: fieldProvider.errorMessage!,
                          onRetry: () => fieldProvider.fetchFields(),
                        )
                      : _buildFieldsList(fieldProvider, bookingProvider),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomCTA(bookingProvider),
    );
  }

  Widget _buildFieldsList(FieldProvider fieldProv, BookingProvider bookingProv) {
    if (fieldProv.fields.isEmpty) {
      return const Center(child: Text('Tidak ada lapangan tersedia'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20.0),
      itemCount: fieldProv.fields.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final field = fieldProv.fields[index];
        final isSelectedField = bookingProv.selectedFieldId == field.id;

        return Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusL,
            side: BorderSide(
              color: isSelectedField ? AppColors.primaryRed : AppColors.borderGrey,
              width: isSelectedField ? 1.5 : 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Photo & Badge
              GestureDetector(
                onTap: () => context.pushNamed('field-detail', pathParameters: {'id': field.id.toString()}),
                child: Stack(
                  children: [
                    Image.network(
                      field.primaryImageUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: AppRadius.borderRadiusS,
                        ),
                        child: Text(
                          field.type.toUpperCase(),
                          style: AppTextStyles.labelUpper.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Field Name & Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.pushNamed('field-detail', pathParameters: {'id': field.id.toString()}),
                            child: Text(
                              field.name,
                              style: AppTextStyles.headingSmall.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${Formatters.currencyShort(field.pricePerHour)}/JAM',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${field.location}',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 16),

                    // Time Slot Grid Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PILIH WAKTU',
                          style: AppTextStyles.labelUpper.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!isSelectedField) {
                              bookingProv.fetchSchedules(field.id);
                            }
                          },
                          child: Text(
                            isSelectedField ? 'Terhubung' : 'Lihat Jadwal',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelectedField ? AppColors.successGreen : AppColors.primaryRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalS,

                    // Slot list
                    if (isSelectedField)
                      _buildTimeSlotGrid(bookingProv, field.pricePerHour)
                    else
                      Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.dividerGrey,
                          borderRadius: AppRadius.borderRadiusM,
                        ),
                        child: Text(
                          'Ketuk "Lihat Jadwal" untuk menampilkan slot',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeSlotGrid(BookingProvider bookingProv, int pricePerHour) {
    if (bookingProv.schedules.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('Jadwal tidak tersedia'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookingProv.schedules.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, idx) {
        final slot = bookingProv.schedules[idx];
        final isSel = bookingProv.isSlotSelected(slot.startTime);

        return TimeSlotChip(
          time: slot.startTime,
          isAvailable: slot.isAvailable,
          isSelected: isSel,
          onTap: () {
            // Kita batasi booking 1 jam per ketuk agar gampang dipahami
            bookingProv.selectSlot(slot.startTime, slot.endTime);
          },
        );
      },
    );
  }

  Widget _buildBottomCTA(BookingProvider bookingProv) {
    final hasSelected = bookingProv.selectedFieldId != null &&
        bookingProv.selectedStartTime != null &&
        bookingProv.selectedEndTime != null;

    if (!hasSelected) return const SizedBox.shrink();

    return Container(
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
          onPressed: () => _handleProceedToConfirmation(bookingProv.selectedFieldId!),
        ),
      ),
    );
  }
}
