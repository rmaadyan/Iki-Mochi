import 'package:flutter/material.dart';

class AppColors {
  // -------- PRIMARY BRAND COLORS (Iki-Mochi) --------
  // Soft Mochi Pink
  static const Color primary = Color(0xFFFF85A7);
  static const Color primaryLight = Color(0xFFFFB6CD);
  static const Color primaryDark = Color(0xFFCC5E79);

  // Secondary Navy (kontras untuk judul / tombol)
  static const Color secondary = Color(0xFF0E3A66);
  static const Color accent = Color(0xFF3B7D57); // leaf green (opsional)

  // -------- STATUS COLORS --------
  static const Color success = Color(0xFF3CCF7F);
  static const Color error = Color(0xFFFF4D4D);
  static const Color warning = Color(0xFFFFB84D);
  static const Color info = Color(0xFF4D9FFF);

  // -------- NEUTRAL / BACKGROUND --------
  static const Color background = Color(0xFFFFF7FC); // soft pinkish white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8EDF2); // light cream-pink
  static const Color inputFillColor = Color(0xFFFDF5F8);

  // -------- TEXT COLORS --------
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color textTertiary = Color(0xFFB5B5B5);

  // -------- SEPARATORS --------
  static const Color separator = Color(0xFFE4D8DE);
  static const Color separatorLight = Color(0xFFF2E9ED);

  // -------- CARDS & CONTAINERS --------
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE8DDE2);

  // -------- GRADIENTS --------
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF85A7), Color(0xFFFFB6CD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF0E3A66), Color(0xFF3C5E8A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // -------- SHADOW --------
  static const Color shadowColor = Color(0x1A000000);

  // -------- DARK THEME --------
  static const Color darkBackground = Color(0xFF0F0F12);
  static const Color darkSurface = Color(0xFF1A1A1E);
  static const Color darkSurfaceVariant = Color(0xFF24242A);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB5B5B5);
  static const Color darkTextTertiary = Color(0xFF7A7A7A);

  static const Color darkSeparator = Color(0xFF2C2C31);
  static const Color darkSeparatorLight = Color(0xFF3A3A40);

  static const Color darkCardBackground = Color(0xFF1A1A1E);
  static const Color darkCardBorder = Color(0xFF3A3A40);
}
