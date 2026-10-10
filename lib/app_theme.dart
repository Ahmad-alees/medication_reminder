import 'package:flutter/material.dart';

/// Medication Reminder — color tokens & theme
/// Based on palette 3: FF6F00 / EAF8BF / 006992 / 27476E / 001D4A
class AppColors {
  AppColors._();

  // ── Palette 3 (from Coolors) ───────────────────────────
  static const Color orange = Color(0xFFFF6F00); // alarm / main CTA
  static const Color lime = Color(0xFFEAF8BF); // light background
  static const Color teal = Color(0xFF006992); // primary brand
  static const Color blue = Color(0xFF27476E); // dark surfaces / tertiary
  static const Color navy = Color(0xFF001D4A); // text / dark background

  // ── Semantic colors (added; not in the palette) ────────
  static const Color success = Color(0xFFC2EABD); // "taken" (from palette 4)
  static const Color successStrong = Color(0xFF2E7D32); // success icons
  static const Color error = Color(0xFFD32F2F); // missed dose / errors
  static const Color warning = orange; // snooze / low stock

  // ── Derived for dark mode (lighter teal for contrast) ──
  static const Color tealLight = Color(0xFF5BB8DC);

  static const Color white = Color(0xFFFFFFFF);
}

class AppTheme {
  AppTheme._();

  // ── Light ──────────────────────────────────────────────
  static final ColorScheme _lightScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.teal,
    onPrimary: AppColors.white,
    secondary: AppColors.orange,
    onSecondary: AppColors.navy, // navy on orange: good contrast
    tertiary: AppColors.blue,
    onTertiary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.white,
    onSurface: AppColors.navy,
  );

  static ThemeData light() => _base(_lightScheme).copyWith(
        scaffoldBackgroundColor: AppColors.lime,
      );

  // ── Dark ───────────────────────────────────────────────
  static final ColorScheme _darkScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.tealLight,
    onPrimary: AppColors.navy,
    secondary: AppColors.orange,
    onSecondary: AppColors.navy,
    tertiary: AppColors.lime,
    onTertiary: AppColors.navy,
    error: Color(0xFFFF8A80),
    onError: AppColors.navy,
    surface: AppColors.blue,
    onSurface: AppColors.white,
  );

  static ThemeData dark() => _base(_darkScheme).copyWith(
        scaffoldBackgroundColor: AppColors.navy,
      );

  // ── Shared component styles ────────────────────────────
  static ThemeData _base(ColorScheme s) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: s,
      appBarTheme: AppBarTheme(
        backgroundColor: s.brightness == Brightness.light
            ? AppColors.teal
            : AppColors.navy,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: s.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      // Main action: "Taken"
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: AppColors.navy,
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      // Secondary action: "Snooze"
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: s.primary,
          side: BorderSide(color: s.primary, width: 1.5),
          minimumSize: const Size.fromHeight(52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.navy,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: s.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: s.primary, width: 2),
        ),
      ),
    );
  }
}

// Usage:
// MaterialApp(
//   theme: AppTheme.light(),
//   darkTheme: AppTheme.dark(),
//   themeMode: ThemeMode.system,
// );