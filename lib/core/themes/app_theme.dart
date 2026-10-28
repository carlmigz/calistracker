import 'package:calistracker/core/constants/app_sizes.dart';
import 'package:calistracker/core/themes/app_colors.dart';
import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final onSurface = isDark ? AppColors.white : AppColors.black;
    final container = isDark
        ? AppColors.containerDark
        : AppColors.containerLight;
    final field = isDark ? AppColors.fieldDark : AppColors.fieldLight;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: AppColors.black,
      secondary: onSurface,
      onSecondary: surface,
      error: AppColors.error,
      onError: AppColors.white,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: field,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,
      fontFamily: AppTextStyles.fontFamily,
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
        fontFamily: AppTextStyles.fontFamily,
        displayColor: onSurface,
        bodyColor: onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: container,
        foregroundColor: onSurface,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: container,
        indicatorColor: AppColors.primary,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: field,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius.r),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: field,
        isDense: true,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: TextStyle(color: onSurface.withValues(alpha: 0.6)),
        labelStyle: TextStyle(color: onSurface.withValues(alpha: 0.8)),
        prefixIconColor: onSurface,
        suffixIconColor: onSurface,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.primary
                : field,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.black
                : onSurface,
          ),
          side: const WidgetStatePropertyAll(BorderSide.none),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: field,
      ),
    );
  }
}
