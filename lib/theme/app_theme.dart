import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // === CORE PALETTE (từ Stitch Otaku design) ===
  static const background   = Color(0xFF0D0D14); // dark navy-black
  static const surface      = Color(0xFF14141E);
  static const surfaceCard  = Color(0xFF1A1A28);
  static const surfaceDim   = Color(0xFF111119);

  // Pink (màu chính - neon sakura pink)
  static const pink         = Color(0xFFFF6B9D);
  static const pinkDark     = Color(0xFFB03060);
  static const onPink       = Color(0xFF000000);

  // Cyan (màu phụ - electric)
  static const cyan         = Color(0xFF00E5FF);
  static const cyanDark     = Color(0xFF007A8C);
  static const onCyan       = Color(0xFF000000);

  // Yellow/Gold
  static const gold         = Color(0xFFE9C400);
  static const onGold       = Color(0xFF1A1600);

  // Red (accent / error / danger)
  static const red          = Color(0xFFFF4444);
  static const onRed        = Color(0xFFFFFFFF);

  // Green (completed)
  static const green        = Color(0xFF00E096);
  static const onGreen      = Color(0xFF000000);

  // Purple
  static const purple       = Color(0xFF7B2FFF);
  static const onPurple     = Color(0xFFFFFFFF);

  // Text colors
  static const textPrimary     = Color(0xFFE4E1ED);
  static const textSecondary   = Color(0xFF9E9AB0);
  static const textDisabled    = Color(0xFF5A5670);

  // Border ink
  static const inkBorder    = Color(0xFF000000);   // thick black borders
  static const inkBorderSoft = Color(0xFF2A2A3E);  // inner borders
  static const inkWhite     = Color(0xFFE4E1ED);   // light outlines

  // Shadow colors (colored drop shadows)
  static const shadowPink   = Color(0xFFFF6B9D);
  static const shadowCyan   = Color(0xFF00E5FF);
  static const shadowGold   = Color(0xFFE9C400);
  static const shadowRed    = Color(0xFFFF4444);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary:   AppColors.pink,
        onPrimary: AppColors.onPink,
        secondary: AppColors.cyan,
        onSecondary: AppColors.onCyan,
        tertiary:  AppColors.gold,
        onTertiary: AppColors.onGold,
        error:     AppColors.red,
        onError:   AppColors.onRed,
        surface:   AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: TextTheme(
        // Tiêu đề lớn - dùng Anton (heavy manga font)
        displayLarge: GoogleFonts.anton(
          fontSize: 56, color: AppColors.textPrimary, letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.anton(
          fontSize: 40, color: AppColors.textPrimary, letterSpacing: 2,
        ),
        displaySmall: GoogleFonts.anton(
          fontSize: 32, color: AppColors.textPrimary, letterSpacing: 1.5,
        ),
        // Headline - Sora bold
        headlineLarge: GoogleFonts.sora(
          fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
        ),
        // Body
        bodyLarge: GoogleFonts.sora(
          fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.sora(
          fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
        ),
        bodySmall: GoogleFonts.sora(
          fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textSecondary,
        ),
        // Label - JetBrains Mono (monospace, cho badges/labels)
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.5,
          color: AppColors.textPrimary,
        ),
        labelMedium: GoogleFonts.jetBrainsMono(
          fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5,
          color: AppColors.textPrimary,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1.5,
          color: AppColors.textSecondary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
