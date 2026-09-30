import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF0D9488); // Teal
  static const Color primaryLight = Color(0xFF14B8A6);
  static const Color primaryDark = Color(0xFF0F766E);
  static const Color primarySubtle = Color(0xFFCCFBF1);

  static const Color accent = Color(0xFFF97316); // Warm Coral / Orange
  static const Color accentLight = Color(0xFFFB923C);
  static const Color accentSubtle = Color(0xFFFFEDD5);

  static const Color secondary = Color(0xFF6366F1); // Indigo
  static const Color secondarySubtle = Color(0xFFEEF2FF);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successSubtle = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSubtle = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSubtle = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSubtle = Color(0xFFDBEAFE);

  // Light Mode Colors
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Mode Colors
  static const Color darkBg = Color(0xFF0B1120);
  static const Color darkSurface = Color(0xFF131D31);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFFB923C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF131D31)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
