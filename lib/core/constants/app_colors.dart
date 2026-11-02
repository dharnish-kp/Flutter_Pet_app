import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Deep Forest Green
  static const Color primary = Color(0xFF0D6E3F);
  static const Color primaryLight = Color(0xFF1A9055);
  static const Color primaryDark = Color(0xFF094D2C);
  static const Color primaryGlow = Color(0x330D6E3F);

  // Accent Palette - Warm Amber Orange
  static const Color accent = Color(0xFFE8721A);
  static const Color accentLight = Color(0xFFF5922E);
  static const Color accentGlow = Color(0x33E8721A);

  // Background
  static const Color background = Color(0xFFF5F3EF);
  static const Color backgroundDark = Color(0xFF0A1A12);
  static const Color surfaceDark = Color(0xFF112318);
  static const Color cardDark = Color(0xFF162D1F);

  // Text Colors
  static const Color textDark = Color(0xFF0F1F16);
  static const Color textMuted = Color(0xFF6B7F74);
  static const Color textLight = Color(0xFFF0EDE8);
  static const Color textSubtle = Color(0xFF9EB3A8);

  // UI Elements
  static const Color cardBg = Colors.white;
  static const Color lightBorder = Color(0xFFE0DDD8);
  static const Color divider = Color(0xFFECE9E4);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D6E3F), Color(0xFF1A9055)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF094D2C), Color(0xFF0D6E3F), Color(0xFF1A9055)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A1A12), Color(0xFF112318)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE8721A), Color(0xFFF5922E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}