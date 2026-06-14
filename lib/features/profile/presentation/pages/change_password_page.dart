import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/validators.dart';
import 'package:bookingku/features/auth/presentation/providers/auth_provider.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/custom_text_field.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.changePassword(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kata sandi berhasil diubah!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      },
      failure: (msg) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: BackAppBar(
        title: 'Ubah Kata Sandi',
        onBack: () => context.pop(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.spacingL),
          children: [
            // Old Password
            CustomTextField(
              controller: _oldPasswordController,
              label: 'KATA SANDI LAMA',
              hint: 'Masukkan kata sandi lama Anda',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (val) => Validators.validateRequired(val, 'Kata sandi lama'),
            ),
            const SizedBox(height: AppSpacing.spacingL),

            // New Password
            CustomTextField(
              controller: _newPasswordController,
              label: 'KATA SANDI BARU',
              hint: 'Minimal 8 karakter',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: Validators.validatePassword,
            ),
            const SizedBox(height: AppSpacing.spacingL),

            // Confirm New Password
            CustomTextField(
              controller: _confirmPasswordController,
              label: 'KONFIRMASI KATA SANDI BARU',
              hint: 'Ulangi kata sandi baru Anda',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (val) => Validators.validateConfirmPassword(val, _newPasswordController.text),
            ),
            const SizedBox(height: AppSpacing.spacingXXL),

            // Submit Button
            PrimaryButton(
              text: 'Simpan Kata Sandi',
              isLoading: authProvider.isLoading,
              onPressed: _changePassword,
            ),
          ],
        ),
      ),
    );
  }
}
