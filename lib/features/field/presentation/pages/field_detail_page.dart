/// Halaman Detail Lapangan (rekomendasi best-practice software engineer).
///
/// Menampilkan galeri foto lapangan, deskripsi lengkap, fasilitas,
/// serta tombol ajakan memesan lapangan ini.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_radius.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/formatters.dart';
import 'package:bookingku/features/field/presentation/providers/field_provider.dart';
import 'package:bookingku/features/booking/presentation/providers/booking_provider.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';
import 'package:bookingku/shared/widgets/loading_widget.dart';
import 'package:bookingku/shared/widgets/app_error_widget.dart';

class FieldDetailPage extends StatefulWidget {
  final int fieldId;

  const FieldDetailPage({
    super.key,
    required this.fieldId,
  });

  @override
  State<FieldDetailPage> createState() => _FieldDetailPageState();
}

class _FieldDetailPageState extends State<FieldDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FieldProvider>().fetchFieldDetail(widget.fieldId);
    });
  }

  void _bookThisField() {
    final bookingProv = context.read<BookingProvider>();
    // Pre-select field di Booking tab
    bookingProv.resetSelection();
    bookingProv.fetchSchedules(widget.fieldId);

    // Navigasi ke tab Booking
    context.goNamed('booking');
  }

  @override
  Widget build(BuildContext context) {
    final fieldProvider = context.watch<FieldProvider>();
    final field = fieldProvider.selectedField;

    return Scaffold(
      appBar: BackAppBar(
        title: field?.name ?? 'Detail Lapangan',
      ),
      body: fieldProvider.isLoading
          ? const LoadingWidget(message: 'Memuat detail lapangan...')
          : fieldProvider.errorMessage != null
              ? AppErrorWidget(
                  message: fieldProvider.errorMessage!,
                  onRetry: () => fieldProvider.fetchFieldDetail(widget.fieldId),
                )
              : field == null
                  ? const Center(child: Text('Lapangan tidak ditemukan'))
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Photo Gallery PageView
                                _buildPhotoGallery(field),
                                const SizedBox(height: 20),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Badges Row
                                      Row(
                                        children: [
                                          _buildBadge(field.type.toUpperCase()),
                                          const SizedBox(width: 8),
                                          _buildBadge(field.format),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Title & Location
                                      Text(
                                        field.name,
                                        style: AppTextStyles.headingLarge.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '📍 ${field.address}',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                      const SizedBox(height: 20),

                                      const Divider(),
                                      const SizedBox(height: 16),

                                      // Description
                                      Text(
                                        'Deskripsi Lapangan',
                                        style: AppTextStyles.headingSmall.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        field.description,
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                      const SizedBox(height: 24),

                                      // Facilities
                                      Text(
                                        'Fasilitas Lapangan',
                                        style: AppTextStyles.headingSmall.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _buildFacilitiesGrid(field.facilities),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom Pricing & Book Button Action
                        _buildBottomAction(field),
                      ],
                    ),
    );
  }

  Widget _buildPhotoGallery(field) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
        itemCount: field.images.length,
        itemBuilder: (context, index) {
          return Image.network(
            field.images[index].imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: AppRadius.borderRadiusS,
      ),
      child: Text(
        text,
        style: AppTextStyles.labelUpper.copyWith(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFacilitiesGrid(List<String> facilities) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: facilities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, idx) {
        return Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.successGreen, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                facilities[idx],
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomAction(field) {
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
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Harga Sewa',
                    style: AppTextStyles.caption,
                  ),
                  Text(
                    Formatters.currency(field.pricePerHour),
                    style: AppTextStyles.price.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'per jam',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: PrimaryButton(
                text: 'Pesan Sekarang',
                onPressed: _bookThisField,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
