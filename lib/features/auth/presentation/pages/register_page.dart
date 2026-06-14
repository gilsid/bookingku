/// Halaman Register.
///
/// Mengimplementasikan form registrasi sesuai desain Figma:
/// - Tombol back
/// - Nama Lengkap, Email, Nomor Telepon, Kata Sandi, Konfirmasi Kata Sandi
/// - Checkbox persetujuan Syarat & Ketentuan
/// - Tombol Daftar Sekarang
/// - Social logins
/// - Footer link ke Login
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/validators.dart';
import 'package:bookingku/features/auth/presentation/providers/auth_provider.dart';
import 'package:bookingku/features/auth/presentation/widgets/social_login_buttons.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';
import 'package:bookingku/shared/widgets/custom_text_field.dart';
import 'package:bookingku/shared/widgets/loading_widget.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan'),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();
      final result = await authProvider.register(
        _nameController.text,
        _emailController.text,
        _phoneController.text,
        _passwordController.text,
      );

      result.when(
        success: (user) {
          if (mounted) {
            context.goNamed('home');
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
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Syarat & Ketentuan'),
        content: const SingleChildScrollView(
          child: Text(
            'Dengan mendaftar di BookingKu, Anda menyetujui bahwa:\n\n'
            '1. Data profil yang diberikan adalah benar dan valid.\n'
            '2. Anda bertanggung jawab penuh atas pesanan lapangan yang Anda buat.\n'
            '3. Pembayaran harus dilakukan dan diverifikasi dengan mengunggah bukti pembayaran yang sah.\n'
            '4. Pembatalan pesanan dapat dilakukan sesuai ketentuan pengelola lapangan.\n'
            '5. BookingKu berhak membatalkan akun jika terbukti melanggar aturan penggunaan.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return LoadingOverlay(
      isLoading: authProvider.isLoading,
      message: 'Mendaftarkan akun...',
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const BackAppBar(title: ''),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Akun Baru',
                    style: AppTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalS,
                  Text(
                    'Lengkapi data dirimu untuk mulai bermain.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Fields
                  CustomTextField(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama lengkap',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                    validator: Validators.validateName,
                  ),
                  AppSpacing.verticalM,
                  CustomTextField(
                    label: 'Email',
                    hint: 'contoh@email.com',
                    controller: _emailController,
                    prefixIcon: Icons.mail_outline,
                    validator: Validators.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AppSpacing.verticalM,
                  CustomTextField(
                    label: 'Nomor Telepon',
                    hint: '081234567890',
                    controller: _phoneController,
                    prefixIcon: Icons.phone_android_outlined,
                    validator: Validators.validatePhone,
                    keyboardType: TextInputType.phone,
                  ),
                  AppSpacing.verticalM,
                  CustomTextField(
                    label: 'Kata Sandi',
                    hint: 'Minimal 8 karakter',
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: Validators.validatePassword,
                  ),
                  AppSpacing.verticalM,
                  CustomTextField(
                    label: 'Konfirmasi Kata Sandi',
                    hint: 'Masukkan kembali kata sandi',
                    controller: _confirmPasswordController,
                    prefixIcon: Icons.lock_clock_outlined,
                    isPassword: true,
                    validator: (value) =>
                        Validators.validateConfirmPassword(value, _passwordController.text),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),

                  // Agree to Terms Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        activeColor: AppColors.primaryRed,
                        onChanged: (val) {
                          setState(() {
                            _agreeToTerms = val ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(
                              'Saya setuju dengan ',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: _showTermsDialog,
                              child: Text(
                                'Syarat & Ketentuan',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              ' yang berlaku.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  PrimaryButton(
                    text: 'Daftar Sekarang',
                    onPressed: _handleRegister,
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.borderGrey)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'ATAU DAFTAR DENGAN',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textHint,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.borderGrey)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social Logins
                  const SocialLoginButtons(),
                  const SizedBox(height: 36),

                  // Footer Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: AppTextStyles.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          'Masuk',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
