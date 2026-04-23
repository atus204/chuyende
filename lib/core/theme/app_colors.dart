import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryDark = Color(0xFFE85520);
  static const Color primaryLight = Color(0xFFFF8F65);

  // Accent
  static const Color accent = Color(0xFFFFD166);
  static const Color accentDark = Color(0xFFE6BB4A);

  // Dark
  static const Color dark = Color(0xFF1A1A2E);
  static const Color darkSecondary = Color(0xFF16213E);
  static const Color darkCard = Color(0xFF0F3460);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFEEEEEE);
  static const Color divider = Color(0xFFF0F0F0);

  // Text
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMedium = Color(0xFF555555);
  static const Color textGrey = Color(0xFF888888);
  static const Color textLight = Color(0xFFBBBBBB);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Status orders
  static const Color statusPending = Color(0xFFFF9800);
  static const Color statusConfirmed = Color(0xFF2196F3);
  static const Color statusPreparing = Color(0xFF9C27B0);
  static const Color statusDelivering = Color(0xFF00BCD4);
  static const Color statusDelivered = Color(0xFF4CAF50);
  static const Color statusCancelled = Color(0xFFF44336);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFF9A5C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFFD166), Color(0xFFFFB347)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFE85520)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
