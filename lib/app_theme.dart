import 'package:flutter/material.dart';

/// Dhakkirni design tokens and Material 3 themes.
class AppColors {
  AppColors._();

  // ── Brand and surface tokens ───────────────────────────
  static const Color background = Color(0xFFF6F8F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color raised = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFD5DDE3);
  static const Color primary = Color(0xFF2B6F8A);
  static const Color primaryDark = Color(0xFF7DBAD3);
  static const Color primaryTint = Color(0xFFDCEBF1);
  static const Color accent = Color(0xFFE9A27B);
  static const Color onAccent = Color(0xFF1B2F45);
  static const Color text = Color(0xFF1B2F45);
  static const Color textSecondary = Color(0xFF5A6B7B);
  static const Color darkBackground = Color(0xFF0F1E2E);
  static const Color darkSurface = Color(0xFF1A2D40);
  static const Color darkRaised = Color(0xFF223A52);
  static const Color darkOutline = Color(0xFF2E4A66);
  static const Color darkText = Color(0xFFE8EEF3);
  static const Color darkTextSecondary = Color(0xFFA9B8C6);

  // ── Semantic tokens ────────────────────────────────────
  static const Color successBackground = Color(0xFFDCEBDD);
  static const Color successText = Color(0xFF2F6B3F);
  static const Color successIcon = Color(0xFF3F8A52);
  static const Color successBackgroundDark = Color(0xFF1F3D2C);
  static const Color successTextDark = Color(0xFFBFE3C6);
  static const Color errorBackground = Color(0xFFF8E4E1);
  static const Color errorText = Color(0xFFA8433B);
  static const Color error = Color(0xFFB5483F);
  static const Color errorDark = Color(0xFFF2A39B);
  static const Color warningBackground = Color(0xFFFBEBDD);
  static const Color warningText = Color(0xFF8A4B1F);
  static const Color warningBackgroundDark = Color(0xFF3B2E24);
  static const Color warningTextDark = Color(0xFFF0B08C);

  static const Color white = Color(0xFFFFFFFF);

  // Compatibility aliases for existing screens during the token migration.
  static const Color lime = background;
  static const Color teal = primary;
  static const Color successStrong = successIcon;
}

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'ThmanyahSans';

  // ── Light ──────────────────────────────────────────────
  static final ColorScheme _lightScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    secondary: AppColors.accent,
    onSecondary: AppColors.onAccent,
    tertiary: AppColors.primaryTint,
    onTertiary: AppColors.text,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.surface,
    onSurface: AppColors.text,
    outline: AppColors.outline,
  );

  static ThemeData light() =>
      _base(_lightScheme)
          .copyWith(scaffoldBackgroundColor: AppColors.background);

  // ── Dark ───────────────────────────────────────────────
  static final ColorScheme _darkScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.darkBackground,
    secondary: AppColors.accent,
    onSecondary: AppColors.onAccent,
    tertiary: AppColors.darkRaised,
    onTertiary: AppColors.darkText,
    error: AppColors.errorDark,
    onError: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkText,
    outline: AppColors.darkOutline,
  );

  static ThemeData dark() =>
      _base(_darkScheme)
          .copyWith(scaffoldBackgroundColor: AppColors.darkBackground);

  // ── Shared component styles ────────────────────────────
  static ThemeData _base(ColorScheme s) {
    final isDark = s.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.text;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return ThemeData(
      useMaterial3: true,
      colorScheme: s,
      fontFamily: fontFamily,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          height: 26 / 18,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 24 / 16, color: textColor),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          color: secondaryTextColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        foregroundColor: textColor,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        indicatorColor: AppColors.accent,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: s.surface,
        elevation: isDark ? 0 : 1,
        shadowColor: AppColors.text.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(
            fontSize: 18,
            height: 26 / 18,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: s.primary,
          side: BorderSide(color: s.primary, width: 1.5),
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(
            fontSize: 18,
            height: 26 / 18,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: s.outline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: s.primary, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(color: s.outline, thickness: 1),
    );
  }
}

// Usage:
// MaterialApp(
//   theme: AppTheme.light(),
//   darkTheme: AppTheme.dark(),
//   themeMode: ThemeMode.system,
// );
