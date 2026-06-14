/// Definisi semua ukuran spacing/padding yang digunakan dalam aplikasi.
///
/// Menggunakan skala konsisten untuk menjaga keseragaman layout.
import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double xxxxl = 40.0;
  static const double xxxxxl = 48.0;

  static const double spacingXS = xs;
  static const double spacingS = s;
  static const double spacingM = m;
  static const double spacingL = l;
  static const double spacingXL = xl;
  static const double spacingXXL = xxl;
  static const double spacing3XL = xxxl;


  // EdgeInsets helpers
  static const EdgeInsets paddingAllS = EdgeInsets.all(s);
  static const EdgeInsets paddingAllM = EdgeInsets.all(m);
  static const EdgeInsets paddingAllL = EdgeInsets.all(l);
  static const EdgeInsets paddingAllXL = EdgeInsets.all(xl);
  static const EdgeInsets paddingAllXXL = EdgeInsets.all(xxl);

  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: l);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(horizontal: xxl);

  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: s);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: m);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: l);

  // SizedBox helpers
  static const SizedBox verticalXS = SizedBox(height: xs);
  static const SizedBox verticalS = SizedBox(height: s);
  static const SizedBox verticalM = SizedBox(height: m);
  static const SizedBox verticalL = SizedBox(height: l);
  static const SizedBox verticalXL = SizedBox(height: xl);
  static const SizedBox verticalXXL = SizedBox(height: xxl);
  static const SizedBox verticalXXXL = SizedBox(height: xxxl);

  static const SizedBox horizontalXS = SizedBox(width: xs);
  static const SizedBox horizontalS = SizedBox(width: s);
  static const SizedBox horizontalM = SizedBox(width: m);
  static const SizedBox horizontalL = SizedBox(width: l);
  static const SizedBox horizontalXL = SizedBox(width: xl);
}
