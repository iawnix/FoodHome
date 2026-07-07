import 'package:flutter/material.dart';
import 'package:foodhome_app/core/theme/tokens.dart';

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.tomato,
    primary: AppColors.tomato,
    secondary: AppColors.leaf,
    tertiary: AppColors.yolk,
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.rice,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.rice,
      foregroundColor: AppColors.soy,
      centerTitle: false,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: AppColors.steam),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: AppColors.yolk.withValues(alpha: 0.35),
      side: const BorderSide(color: AppColors.steam),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.tomato.withValues(alpha: 0.14),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: AppColors.soy,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.soy,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.soy),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    ),
  );
}
