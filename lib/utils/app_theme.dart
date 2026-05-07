import 'package:flutter/material.dart';

class AppTheme {
  // ── Bocchi the Rock! Character Colors ────────────────────────
  // 🩷 Bocchi (Hitori Gotoh) — soft pink
  static const Color primary = Color(0xFFE8839B);
  static const Color primaryLight = Color(0xFFF2ABBA);

  // 💙 Ryo Yamada — cool deep blue
  static const Color secondary = Color(0xFF4A6FA5);

  // 💛 Nijika Ijichi — warm gold (income = positive!)
  static const Color income = Color(0xFFF5C542);

  // ❤️ Kita Ikuyo — vivid red (expense = spending)
  static const Color expense = Color(0xFFE5534B);

  // 🎸 Dark tones inspired by Ryo's blue
  static const Color surface = Color(0xFF1B2A4A);
  static const Color background = Color(0xFF0D1525);
  static const Color cardBg = Color(0xFF142036);

  // Category colors mixing all 4 characters
  static const List<Color> categoryColors = [
    Color(0xFFF5C542), // Nijika gold
    Color(0xFF4A6FA5), // Ryo blue
    Color(0xFFE8839B), // Bocchi pink
    Color(0xFFE5534B), // Kita red
    Color(0xFF6DAEDB), // Ryo light blue
    Color(0xFFF2ABBA), // Bocchi light pink
    Color(0xFFD4A03C), // Nijika deep gold
    Color(0xFF8AB4E8), // Ryo sky blue
    Color(0xFFE07B8E), // Bocchi rose
    Color(0xFF7A8BA8), // Ryo muted blue
  ];

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: cardBg,
        onPrimary: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        hintStyle: const TextStyle(color: Color(0xFF4B5563)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Color(0xFFE2E8F0)),
        bodyMedium: TextStyle(color: Color(0xFF9CA3AF)),
        bodySmall: TextStyle(color: Color(0xFF6B7280)),
      ),
    );
  }
}
