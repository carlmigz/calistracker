import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Sizes and weights only; colors come from the theme.
class AppTextStyles {
  AppTextStyles._();

  static const fontFamily = 'Poppins';
  static const headingFontFamily = 'Ethnocentric';

  static TextStyle get heading => TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 22.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get title => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get body =>
      TextStyle(fontFamily: fontFamily, fontSize: 14.sp);

  static TextStyle get caption =>
      TextStyle(fontFamily: fontFamily, fontSize: 12.sp);

  static TextStyle get button => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get input =>
      TextStyle(fontFamily: fontFamily, fontSize: 14.sp);
}
