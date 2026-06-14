/// Definisi semua border radius yang digunakan dalam aplikasi.
import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;

  static final BorderRadius borderRadiusS = BorderRadius.circular(s);
  static final BorderRadius borderRadiusM = BorderRadius.circular(m);
  static final BorderRadius borderRadiusL = BorderRadius.circular(l);
  static final BorderRadius borderRadiusXL = BorderRadius.circular(xl);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(full);
}
