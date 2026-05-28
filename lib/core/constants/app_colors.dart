import 'package:flutter/material.dart';

/// MangaFlow Otaku Edition Design System Colors
/// Based on Stitch Cyber-Manga dark theme
class AppColors {
  // === PRIMARY - Sakura Pink ===
  static const Color primary = Color(0xFFFFB1C5);
  static const Color primaryContainer = Color(0xFFFF6B9D);
  static const Color primaryDark = Color(0xFFFF6B9D);
  static const Color primaryLight = Color(0xFFFFD9E1);
  static const Color onPrimary = Color(0xFF650030);
  static const Color onPrimaryContainer = Color(0xFF6E0035);
  static const Color inversePrimary = Color(0xFFAC2A5D);

  // === SECONDARY - Electric Purple ===
  static const Color secondary = Color(0xFFDCB8FF);
  static const Color secondaryContainer = Color(0xFF7701D0);
  static const Color onSecondary = Color(0xFF480081);
  static const Color onSecondaryContainer = Color(0xFFDCB7FF);

  // === TERTIARY - Cyan ===
  static const Color tertiary = Color(0xFF00DBE9);
  static const Color tertiaryContainer = Color(0xFF00AFBA);
  static const Color onTertiary = Color(0xFF00363A);

  // === BACKGROUND & SURFACE (Deep Ink Black) ===
  static const Color background = Color(0xFF13131B);
  static const Color surface = Color(0xFF13131B);
  static const Color surfaceDark = Color(0xFF1F1F28);
  static const Color surfaceContainer = Color(0xFF1F1F28);
  static const Color surfaceContainerHigh = Color(0xFF292932);
  static const Color surfaceContainerHighest = Color(0xFF34343D);
  static const Color surfaceContainerLow = Color(0xFF1B1B23);
  static const Color surfaceContainerLowest = Color(0xFF0D0D16);
  static const Color surfaceBright = Color(0xFF393842);
  static const Color surfaceVariant = Color(0xFF34343D);
  static const Color cardBackground = Color(0xFF1A1A1A);

  // === ON SURFACE (Text/Icon on dark backgrounds) ===
  static const Color onSurface = Color(0xFFE4E1ED);
  static const Color onSurfaceVariant = Color(0xFFDDBFC5);
  static const Color onBackground = Color(0xFFE4E1ED);
  static const Color textPrimary = Color(0xFFE4E1ED);
  static const Color textSecondary = Color(0xFFDDBFC5);
  static const Color textLight = Color(0xFFFFFFFF);

  // === GRADIENTS ===
  static const List<Color> primaryGradient = [primaryContainer, secondaryContainer];
  static const List<Color> panelAccentGradient = [Color(0xFFFF6B9D), Color(0xFF7701D0)];

  // === STATUS ===
  static const Color success = Color(0xFF00DBE9);
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color warning = Color(0xFFFFB1C5);
  static const Color info = Color(0xFF00DBE9);

  // === BORDER & OUTLINE ===
  static const Color border = Color(0xFF574146);
  static const Color outline = Color(0xFFA58A90);
  static const Color outlineVariant = Color(0xFF574146);
  static const Color divider = Color(0xFF574146);

  // === LEGACY (kept for compatibility) ===
  static const Color grey = Color(0xFFA58A90);
  static const Color greyLight = Color(0xFF34343D);
  static const Color greyDark = Color(0xFF0D0D16);
  static const Color tagFree = Color(0xFF00DBE9);
  static const Color tagPremium = Color(0xFFFF6B9D);
  static const Color searchBarBackground = Color(0xFF1F1F28);
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  static const Color overlayDark = Color(0xB3000000);
}
