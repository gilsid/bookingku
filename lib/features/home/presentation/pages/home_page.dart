/// Halaman Home (Beranda).
///
/// Mengimplementasikan layout beranda sesuai desain Figma:
/// - AppBar dengan notifikasi badge
/// - Banner Utama (LIVE Lapangan Hari Ini)
/// - Promo Spesial horizontal scroll list
/// - Jadwal Terpopuler list
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/theme/app_radius.dart';
import 'package:bookingku/core/utils/formatters.dart';
import 'package:bookingku/features/home/presentation/providers/home_provider.dart';
import 'package:bookingku/features/home/presentation/widgets/promo_card.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/section_header.dart';
import 'package:bookingku/shared/widgets/loading_widget.dart';
import 'package:bookingku/shared/widgets/app_error_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });
  }

  void _copyPromoCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode promo "$code" berhasil disalin!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      appBar: BookingKuAppBar(
        notificationCount: 2, // Hardcoded mock badge count
        onNotificationTap: () => context.pushNamed('notification'),
      ),
      body: homeProvider.isLoading
          ? const LoadingWidget(message: 'Memuat beranda...')
          : homeProvider.errorMessage != null
              ? AppErrorWidget(
                  message: homeProvider.errorMessage!,
                  onRetry: () => homeProvider.loadHomeData(),
                )
              : RefreshIndicator(
                  color: AppColors.primaryRed,
                  onRefresh: () => homeProvider.loadHomeData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Banner Utama
                        _buildHeroBanner(context),
                        const SizedBox(height: 28),

                        // Section Promo Spesial
                        SectionHeader(
                          title: 'Promo Spesial',
                          actionText: 'Lihat Semua',
                          onAction: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Halaman promo akan segera hadir!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        AppSpacing.verticalM,
                        _buildPromoList(homeProvider),
                        const SizedBox(height: 28),

                        // Section Jadwal Terpopuler
                        const SectionHeader(
                          title: 'Jadwal Terpopuler',
                        ),
                        AppSpacing.verticalM,
                        _buildPopularSchedules(homeProvider),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: AppColors.bannerGradient,
        borderRadius: AppRadius.borderRadiusXL,
        image: DecorationImage(
          image: const NetworkImage(
              'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=600'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primaryDark.withOpacity(0.85),
            BlendMode.srcOver,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: AppRadius.borderRadiusS,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fiber_manual_record, size: 8, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: AppTextStyles.labelUpper.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'LAPANGAN HARI INI',
                style: AppTextStyles.labelUpper.copyWith(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          AppSpacing.verticalM,
          Text(
            'Tersedia 3 Lapangan\nMalam Ini',
            style: AppTextStyles.headingMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.verticalXL,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              minimumSize: const Size(160, 44),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderRadiusM,
              ),
            ),
            onPressed: () => context.goNamed('booking'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pesan Sekarang',
                  style: AppTextStyles.buttonText.copyWith(fontSize: 14),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoList(HomeProvider provider) {
    if (provider.banners.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('Tidak ada promo aktif')),
      );
    }
    return SizedBox(
      height: 165,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: provider.banners.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final banner = provider.banners[index];
          return PromoCard(
            banner: banner,
            onTap: () => _copyPromoCode(banner.code),
          );
        },
      ),
    );
  }

  Widget _buildPopularSchedules(HomeProvider provider) {
    if (provider.popularSchedules.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: Text('Tidak ada jadwal populer saat ini')),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.popularSchedules.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final schedule = provider.popularSchedules[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusM,
            side: const BorderSide(color: AppColors.borderGrey, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Time Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: AppRadius.borderRadiusM,
                  ),
                  child: Text(
                    schedule.time,
                    style: AppTextStyles.headingSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Field Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.fieldName,
                        style: AppTextStyles.headingSmall.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        schedule.type,
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${Formatters.currency(schedule.pricePerHour)}/jam',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Action Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    minimumSize: const Size(64, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderRadiusS,
                    ),
                  ),
                  onPressed: () => context.goNamed('booking'),
                  child: const Text('Pilih', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
