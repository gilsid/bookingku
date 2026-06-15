import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/features/auth/presentation/providers/auth_provider.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    final userName = user?.name ?? 'Ahmad Reza';
    final userEmail = user?.email ?? 'ahmad.reza@email.com';
    final userPhone = user?.phone ?? '+62 812 3456 7890';
    final userAvatar = user?.profileImageUrl;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: BookingKuAppBar(
        leadingAction: IconButton(
          icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pengaturan aplikasi sedang dikembangkan'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        onNotificationTap: () => context.pushNamed('notification'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingL,
          vertical: AppSpacing.spacingXL,
        ),
        children: [
          // Avatar & User Details Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.spacingXL),
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
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderGrey, width: 2),
                      ),
                      child: ClipOval(
                        child: userAvatar != null
                            ? Image.network(
                                userAvatar,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person, size: 48, color: AppColors.primaryRed),
                              )
                            : const Icon(Icons.person, size: 48, color: AppColors.primaryRed),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => context.pushNamed('edit-profile'),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: AppColors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // User info
                Text(
                  userName,
                  style: AppTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userPhone,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userEmail,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spacingXL),

          // Menu List
          Container(
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
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profil',
                  onTap: () => context.pushNamed('edit-profile'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: AppColors.dividerGrey, height: 1),
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Ubah Kata Sandi',
                  onTap: () => context.pushNamed('change-password'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: AppColors.dividerGrey, height: 1),
                ),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Pusat Bantuan',
                  onTap: () {
                    _showHelpDialog(context);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(color: AppColors.dividerGrey, height: 1),
                ),
                _buildMenuItem(
                  icon: Icons.description_outlined,
                  title: 'Syarat & Ketentuan',
                  onTap: () {
                    _showTermsDialog(context);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spacingXXL),

          // Logout Button
          CustomOutlinedButton(
            text: 'Keluar',
            onPressed: () {
              _showLogoutConfirmation(context, authProvider);
            },
          ),
          const SizedBox(height: AppSpacing.spacingXL),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryDark.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryDark,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: 18,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showLogoutConfirmation(BuildContext outerContext, AuthProvider authProvider) {
    showDialog(
      context: outerContext,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Konfirmasi Keluar',
            style: AppTextStyles.headingSmall,
          ),
          content: Text(
            'Apakah Anda yakin ingin keluar dari akun Anda?',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                final result = await authProvider.logout();
                if (context.mounted) Navigator.pop(context);
                result.when(
                  success: (_) {
                    outerContext.goNamed('login');
                  },
                  failure: (_) {},
                );
              },
              child: const Text(
                'Keluar',
                style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pusat Bantuan',
                style: AppTextStyles.headingSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Hubungi customer service kami jika Anda memerlukan bantuan terkait pemesanan, pembayaran, atau pembatalan lapangan.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 20),
              _buildContactItem(Icons.phone, 'Call Center', '+62 21 5555 1234'),
              const SizedBox(height: 12),
              _buildContactItem(Icons.chat_bubble_outline, 'WhatsApp Chat', '+62 812 9999 8888'),
              const SizedBox(height: 12),
              _buildContactItem(Icons.email_outlined, 'Email Support', 'support@bookingku.com'),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryRed, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  void _showTermsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(
                    'Syarat & Ketentuan',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '1. Reservasi Lapangan\nSetiap pemesanan lapangan harus dilakukan minimal 3 jam sebelum waktu pertandingan yang dijadwalkan.\n\n2. Kebijakan Pembayaran\nPembayaran harus diselesaikan maksimal 1 jam setelah pemesanan dilakukan. Jika tidak diselesaikan, sistem akan membatalkan pemesanan secara otomatis.\n\n3. Pembatalan & Pengembalian Dana\nPembatalan pemesanan dapat dilakukan maksimal 24 jam sebelum jadwal pertandingan. Uang yang telah dibayarkan akan dikembalikan dalam bentuk saldo aplikasi (Refund Wallet).\n\n4. Aturan Penggunaan Lapangan\nPengguna wajib mengenakan sepatu olahraga yang sesuai (sepatu futsal/mini soccer). Kerusakan pada properti lapangan yang disebabkan kelalaian pengguna akan menjadi tanggung jawab penyewa.',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
