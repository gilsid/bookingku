import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/validators.dart';
import 'package:bookingku/features/auth/presentation/providers/auth_provider.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/custom_text_field.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final result = await authProvider.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
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
        title: 'Edit Profil',
        onBack: () => context.pop(),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.spacingL),
          children: [
            // Name Field
            CustomTextField(
              controller: _nameController,
              label: 'NAMA LENGKAP',
              hintText: 'Masukkan nama lengkap',
              prefixIcon: Icons.person_outline,
              validator: (val) => Validators.validateRequired(val, 'Nama lengkap'),
            ),
            const SizedBox(height: AppSpacing.spacingL),

            // Phone Field
            CustomTextField(
              controller: _phoneController,
              label: 'NOMOR TELEPON',
              hintText: '081234567890',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: Validators.validatePhone,
            ),
            const SizedBox(height: AppSpacing.spacingL),

            // Email Field
            CustomTextField(
              controller: _emailController,
              label: 'EMAIL',
              hintText: 'contoh@email.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: AppSpacing.spacingXXL),

            // Save Button
            CustomButton(
              text: 'Simpan Perubahan',
              isLoading: authProvider.isLoading,
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}
