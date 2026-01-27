import 'package:flutter/material.dart';
import 'package:easy_cart/core/themes/app_color.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColor.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: AppColor.primary,
            brightness: Brightness.dark,
          ).copyWith(
            primary: AppColor.primary,
            secondary: AppColor.secondary,
            surface: AppColor.white,
            onPrimary: AppColor.white,
            error: AppColor.error,
          ),
    );

    return base.copyWith(
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColor.textPrimary),
        bodyMedium: TextStyle(color: AppColor.textPrimary),
        bodySmall: TextStyle(color: AppColor.textSecondary),
        titleLarge: TextStyle(
          color: AppColor.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: AppColor.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: TextStyle(color: AppColor.textSecondary),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.background,
        foregroundColor: AppColor.textPrimary,
        elevation: 0,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColor.primary,
        unselectedItemColor: AppColor.secondary,
        backgroundColor: AppColor.white,
        elevation: 8,
      ),

      cardTheme: CardThemeData(
        color: AppColor.white,
        shadowColor: AppColor.textPrimary.withAlpha(50),
        elevation: 1,
        surfaceTintColor: Colors.transparent,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
