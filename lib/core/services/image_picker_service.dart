/// Service untuk memilih gambar dari galeri atau kamera.
///
/// Digunakan untuk upload bukti pembayaran dan foto profil.
/// Mendukung format: jpg, jpeg, png dengan maksimum 5MB.
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:bookingku/core/constants/app_constants.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pilih gambar dari galeri.
  Future<File?> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (image != null) {
      return _validateImage(File(image.path));
    }
    return null;
  }

  /// Ambil gambar dari kamera.
  Future<File?> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (image != null) {
      return _validateImage(File(image.path));
    }
    return null;
  }

  /// Validasi ukuran dan format gambar.
  Future<File?> _validateImage(File file) async {
    final size = await file.length();
    if (size > AppConstants.maxImageSizeBytes) {
      throw ImagePickerException('Ukuran gambar maksimal ${AppConstants.maxImageSizeMB}MB');
    }

    final extension = file.path.split('.').last.toLowerCase();
    if (!AppConstants.allowedImageFormats.contains(extension)) {
      throw ImagePickerException('Format gambar harus jpg, jpeg, atau png');
    }

    return file;
  }
}

/// Exception khusus untuk error image picker.
class ImagePickerException implements Exception {
  final String message;
  ImagePickerException(this.message);

  @override
  String toString() => message;
}
