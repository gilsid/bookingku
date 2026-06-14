/// Halaman Login.
///
/// Implementasi visual login dari Figma:
/// - Logo & nama "BookingKu"
/// - Judul & Subjudul selamat datang
/// - Inputs email/phone & password
/// - Tombol Masuk
/// - Social Login buttons
/// - Navigation ke halaman Register
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();
      final result = await authProvider.login(
        _emailPhoneController.text,
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

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lupa Kata Sandi?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Masukkan email Anda untuk menerima link reset kata sandi.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'contoh@email.com',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Link reset kata sandi telah dikirim ke email Anda.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Kirim'),
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
      message: 'Sedang masuk...',
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Header Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.sports_soccer,
                        color: AppColors.primaryRed,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'BookingKu',
                        style: AppTextStyles.headingMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // Title
                  Text(
                    'Selamat Datang Kembali',
                    style: AppTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalS,
                  Text(
                    'Masuk untuk melanjutkan pemesanan lapangan favoritmu.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 32),

                  // Fields
                  CustomTextField(
                    label: 'Email atau Nomor Telepon',
                    hint: 'Masukkan email atau no telp',
                    controller: _emailPhoneController,
                    prefixIcon: Icons.mail_outline,
                    validator: Validators.validateEmailOrPhone,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AppSpacing.verticalXL,
                  CustomTextField(
                    label: 'Kata Sandi',
                    hint: 'Masukkan kata sandi Anda',
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    validator: Validators.validatePassword,
                    textInputAction: TextInputAction.done,
                  ),
                  AppSpacing.verticalM,

                  // Lupa Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _showForgotPasswordDialog,
                      child: Text(
                        'Lupa Kata Sandi?',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  PrimaryButton(
                    text: 'Masuk',
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.borderGrey)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'ATAU MASUK DENGAN',
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

                  // Footer Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun? ',
                        style: AppTextStyles.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.pushNamed('register'),
                        child: Text(
                          'Daftar Sekarang',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
