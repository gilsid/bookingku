import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bookingku/core/theme/app_colors.dart';
import 'package:bookingku/core/theme/app_text_styles.dart';
import 'package:bookingku/core/theme/app_spacing.dart';
import 'package:bookingku/core/utils/formatters.dart';
import 'package:bookingku/core/services/image_picker_service.dart';
import 'package:bookingku/features/auth/presentation/providers/auth_provider.dart';
import 'package:bookingku/features/booking/presentation/providers/booking_provider.dart';
import 'package:bookingku/features/payment/presentation/providers/payment_provider.dart';
import 'package:bookingku/shared/widgets/custom_app_bar.dart';
import 'package:bookingku/shared/widgets/custom_button.dart';

class UploadProofPage extends StatefulWidget {
  const UploadProofPage({super.key});

  @override
  State<UploadProofPage> createState() => _UploadProofPageState();
}

class _UploadProofPageState extends State<UploadProofPage> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  File? _selectedImage;
  bool _isSimulatedUpload = false;
  bool _isSubmitting = false;

  Future<void> _pickImage(bool fromCamera) async {
    try {
      File? image;
      if (fromCamera) {
        image = await _imagePickerService.pickFromCamera();
      } else {
        image = await _imagePickerService.pickFromGallery();
      }

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _isSimulatedUpload = false;
        });
      }
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  void _simulateUpload() {
    setState(() {
      _isSimulatedUpload = true;
      _selectedImage = null;
    });
    _showSnackBar('Simulasi: Bukti pembayaran terpilih (bukti_transfer_bca.png)');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitProof() async {
    if (_selectedImage == null && !_isSimulatedUpload) {
      _showSnackBar('Silakan upload atau pilih bukti pembayaran terlebih dahulu');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final authProvider = context.read<AuthProvider>();
    final bookingProvider = context.read<BookingProvider>();
    
    final userId = authProvider.currentUser?.id ?? 0;
    final booking = bookingProvider.currentBooking;

    if (booking == null) {
      _showSnackBar('Terjadi kesalahan: Booking tidak ditemukan');
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    // Path mock / path asli
    final path = _selectedImage?.path ?? 'assets/images/mock_receipt.png';

    final result = await bookingProvider.uploadProof(booking.bookingCode, path, userId);
    
    result.when(
      success: (updatedBooking) async {
        // Auto verify untuk kemudahan demo agar status langsung "Selesai" atau "Confirmed"
        await bookingProvider.autoVerifyPayment(booking.bookingCode, userId);
        
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
          context.pushReplacementNamed('payment-success');
        }
      },
      failure: (msg) {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
          _showSnackBar(msg);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();
    final bookingProvider = context.watch<BookingProvider>();
    final account = paymentProvider.selectedAccount;
    final booking = bookingProvider.currentBooking;

    if (booking == null || account == null) {
      return Scaffold(
        appBar: const BackAppBar(title: 'Upload Bukti'),
        body: Center(
          child: Text(
            'Data transaksi tidak lengkap.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      );
    }

    final rentPrice = booking.totalPrice;
    const serviceFee = 10000;
    final promoDiscount = booking.discountAmount;
    final totalPay = rentPrice + serviceFee - promoDiscount;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: BackAppBar(
        title: 'Upload Bukti',
        onBack: () => context.pop(),
      ),
      body: _isSubmitting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryRed),
                  SizedBox(height: 16),
                  Text('Mengunggah bukti pembayaran...', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.spacingL),
              children: [
                // Info Transfer
                Container(
                  padding: const EdgeInsets.all(AppSpacing.spacingL),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            account.provider,
                            style: AppTextStyles.headingSmall.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              account.type == 'ewallet' ? 'E-Wallet' : 'Virtual Account',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.borderGrey, height: 1),
                      const SizedBox(height: 16),
                      Text(
                        'NOMOR REKENING / VA',
                        style: AppTextStyles.labelUpper.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            account.accountNumber,
                            style: AppTextStyles.headingSmall.copyWith(
                              fontSize: 20,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: AppColors.primaryRed, size: 20),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: account.accountNumber));
                              _showSnackBar('Nomor rekening berhasil disalin!');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'NAMA PENERIMA',
                        style: AppTextStyles.labelUpper.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        account.accountName,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.borderGrey, height: 1),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jumlah Transfer',
                            style: AppTextStyles.bodyMedium,
                          ),
                          Text(
                            Formatters.formatCurrency(totalPay),
                            style: AppTextStyles.price.copyWith(
                              fontSize: 16,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingXL),

                // Upload Box
                Text(
                  'Upload Bukti Pembayaran',
                  style: AppTextStyles.headingSmall.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingM),

                GestureDetector(
                  onTap: () {
                    _showUploadOptions();
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: (_selectedImage != null || _isSimulatedUpload)
                            ? AppColors.successGreen
                            : AppColors.borderGrey,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : _isSimulatedUpload
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.successGreen,
                                    size: 54,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'bukti_transfer_${account.provider.toLowerCase().replaceAll(' ', '_')}.png',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Simulasi Upload Berhasil (Tap untuk ganti)',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    color: AppColors.textSecondary.withOpacity(0.6),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Pilih Foto Bukti Pembayaran',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Format JPG, PNG, maks 5MB',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingXXL),

                // Action Buttons
                CustomButton(
                  text: 'Kirim Bukti Pembayaran',
                  onPressed: _submitProof,
                ),
                const SizedBox(height: AppSpacing.spacingM),
                TextButton(
                  onPressed: _simulateUpload,
                  child: Text(
                    'Simulasikan Unggah Cepat (Gunakan Resi Mock)',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingXL),
              ],
            ),
    );
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pilih Sumber Gambar',
                  style: AppTextStyles.headingSmall.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOptionItem(
                      icon: Icons.camera_alt_outlined,
                      label: 'Kamera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(true);
                      },
                    ),
                    _buildOptionItem(
                      icon: Icons.photo_library_outlined,
                      label: 'Galeri',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(false);
                      },
                    ),
                    _buildOptionItem(
                      icon: Icons.sim_card_outlined,
                      label: 'Simulasi',
                      onTap: () {
                        Navigator.pop(context);
                        _simulateUpload();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primaryRed,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
