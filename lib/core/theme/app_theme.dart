import 'package:flutter/material.dart';
import 'package:pinapp_test/core/constants/colors.dart';

/// ThemeData personalizado con los colores de PinApp
class PinAppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: PinAppColors.navyBlue,
        onPrimary: PinAppColors.white,
        secondary: PinAppColors.turquoise,
        onSecondary: PinAppColors.white,
        error: PinAppColors.error,
        onError: PinAppColors.white,
        surface: PinAppColors.surface,
        onSurface: PinAppColors.textPrimary,
        surfaceContainerHighest: PinAppColors.lightGray,
        primaryContainer: PinAppColors.lightBlue,
        onPrimaryContainer: PinAppColors.darkBlue,
        secondaryContainer: PinAppColors.lightBlue,
        onSecondaryContainer: PinAppColors.darkBlue,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: PinAppColors.navyBlue,
        foregroundColor: PinAppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: PinAppColors.white,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: PinAppColors.cardBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PinAppColors.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: PinAppColors.turquoise,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          color: PinAppColors.mediumGray,
          fontSize: 16,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: PinAppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: PinAppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: PinAppColors.textPrimary,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: PinAppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: PinAppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: PinAppColors.textSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: PinAppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: PinAppColors.textPrimary,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: PinAppColors.textSecondary,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: PinAppColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: PinAppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: PinAppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PinAppColors.navyBlue,
          foregroundColor: PinAppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: PinAppColors.navyBlue,
        size: 24,
      ),
      dividerTheme: const DividerThemeData(
        color: PinAppColors.lightGray,
        thickness: 1,
        space: 1,
      ),
      scaffoldBackgroundColor: PinAppColors.background,
    );
  }
}
