import 'package:calistracker/core/themes/colors.dart';
import 'package:flutter/material.dart';

// Light Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Poppins',
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.navigationBarLight,
  ),
  appBarTheme: AppBarTheme(backgroundColor: AppColors.appBarLight),
  colorScheme: ColorScheme.light(
    surface: AppColors.scaffoldColorLight,
    primary: AppColors.primary,
    secondary: AppColors.black,
  ),
);

// Dark Theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Poppins',
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.navigationBarDark,
  ),
  appBarTheme: AppBarTheme(backgroundColor: AppColors.appBarDark),
  colorScheme: ColorScheme.dark(
    surface: AppColors.scaffoldColorDark,
    primary: AppColors.primary,
    secondary: AppColors.white,
  ),
);
