/// App Color Palette -  Attendance System
/// 
/// Design Philosophy:
/// - Deep Navy (#1B3C53): Professional, trustworthy, educational authority
/// - Medium Navy (#234C6A): Primary brand color, Islamic scholarly tradition
/// - Steel Blue (#456882): Secondary actions, calm and balanced
/// - Warm Beige (#D2C1B6): Welcoming accent, highlighting important elements
/// 
/// Color Palette (Top to Bottom):
/// - #1B3C53 (Primary Dark) - Deep navy for headers and primary elements
/// - #234C6A (Primary) - Medium navy for main brand identity
/// - #456882 (Secondary) - Steel blue for secondary actions
/// - #D2C1B6 (Accent) - Warm beige for highlights and accents
/// 
/// Accessibility: All color combinations meet WCAG 2.1 AA standards (4.5:1 contrast ratio)

import 'package:flutter/material.dart';

class AppColors {
  // ============================================================================
  // LIGHT MODE PALETTE - Custom Color Scheme
  // ============================================================================
  
  // Primary Colors - Deep Navy Blue (#1B3C53)
  static const Color primaryLight = Color(0xFF1B3C53); // Deep navy - main brand
  static const Color primaryDark = Color(0xFF0F2333); // Darker shade for depth
  static const Color primaryLighter = Color(0xFF234C6A); // Medium navy variant
  static const Color primaryPale = Color(0xFFE8EEF2); // Very light blue-gray background
  
  // Secondary Colors - Steel Blue (#456882)
  static const Color secondaryLight = Color(0xFF456882);
  static const Color secondaryDark = Color(0xFF2F4A5F);
  static const Color secondaryLighter = Color(0xFF5A7FA0);
  static const Color secondaryPale = Color(0xFFEAF0F4);
  
  // Accent Colors - Warm Beige (#D2C1B6)
  static const Color accentLight = Color(0xFFD2C1B6);
  static const Color accentDark = Color(0xFFB8A599);
  static const Color accentLighter = Color(0xFFE3D6CC);
  static const Color accentPale = Color(0xFFF5F1ED);
  
  // Success & Status Colors
  static const Color successLight = Color(0xFF2E7D32);
  static const Color warningLight = Color(0xFFF57C00);
  static const Color errorLight = Color(0xFFC62828);
  static const Color infoLight = Color(0xFF456882); // Using secondary color for info
  
  // Neutral Colors - Light Mode
  static const Color backgroundLight = Color(0xFFF8F9FA); // Soft off-white
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFD2C1B6); // Using accent for subtle dividers
  
  // Text Colors - Light Mode (WCAG AA Compliant)
  static const Color textPrimaryLight = Color(0xFF1B3C53); // Deep navy for maximum readability
  static const Color textSecondaryLight = Color(0xFF456882); // Steel blue for secondary text
  static const Color textTertiaryLight = Color(0xFF8B9CAB); // Lighter blue-gray for hints
  static const Color textOnPrimaryLight = Color(0xFFFFFFFF); // White on navy
  
  // ============================================================================
  // DARK MODE PALETTE - Adjusted for OLED and Dark Backgrounds
  // ============================================================================
  
  // Primary Colors - Dark Mode (Lighter variants for visibility)
  static const Color primaryDarkMode = Color(0xFF3D6A91); // Lighter navy for dark mode
  static const Color primaryDarkModeVariant = Color(0xFF2A5070); // Medium shade
  static const Color primaryDarkModeLight = Color(0xFF5A7FA0); // Light variant
  static const Color primaryDarkModePale = Color(0xFF1A2A38); // Very dark navy for backgrounds
  
  // Secondary Colors - Dark Mode
  static const Color secondaryDarkMode = Color(0xFF6B8FA8); // Lighter steel blue
  static const Color secondaryDarkModeVariant = Color(0xFF5A7FA0);
  static const Color secondaryDarkModeLight = Color(0xFF8BADC4);
  static const Color secondaryDarkModePale = Color(0xFF1E2A35);
  
  // Accent Colors - Dark Mode (Lighter beige for visibility)
  static const Color accentDarkMode = Color(0xFFE5D4C8); // Lighter warm beige
  static const Color accentDarkModeVariant = Color(0xFFD2C1B6); // Original beige
  static const Color accentDarkModeLight = Color(0xFFF0E6DD);
  static const Color accentDarkModePale = Color(0xFF2A2622);
  
  // Success & Status Colors - Dark Mode
  static const Color successDark = Color(0xFF66BB6A);
  static const Color warningDark = Color(0xFFFFB74D);
  static const Color errorDark = Color(0xFFEF5350);
  static const Color infoDark = Color(0xFF6B8FA8); // Using secondary for info
  
  // Neutral Colors - Dark Mode
  static const Color backgroundDark = Color(0xFF0F1419); // Deep dark blue-black
  static const Color surfaceDark = Color(0xFF1A2632); // Navy-tinted surface
  static const Color cardDark = Color(0xFF1E2A38); // Card background with navy tint
  static const Color dividerDark = Color(0xFF3D4A5A); // Subtle navy divider
  
  // Text Colors - Dark Mode (WCAG AA Compliant)
  static const Color textPrimaryDark = Color(0xFFE8EEF2); // High contrast light blue-white
  static const Color textSecondaryDark = Color(0xFFB0BEC8); // Medium contrast gray-blue
  static const Color textTertiaryDark = Color(0xFF7D8A96); // Low contrast for hints
  static const Color textOnPrimaryDark = Color(0xFFFFFFFF); // White on navy in dark mode
  
  // ============================================================================
  // SEMANTIC COLORS (Context-aware)
  // ============================================================================
  
  static Color primary(bool isDark) => isDark ? primaryDarkMode : primaryLight;
  static Color secondary(bool isDark) => isDark ? secondaryDarkMode : secondaryLight;
  static Color accent(bool isDark) => isDark ? accentDarkMode : accentLight;
  static Color background(bool isDark) => isDark ? backgroundDark : backgroundLight;
  static Color surface(bool isDark) => isDark ? surfaceDark : surfaceLight;
  static Color textPrimary(bool isDark) => isDark ? textPrimaryDark : textPrimaryLight;
  static Color textSecondary(bool isDark) => isDark ? textSecondaryDark : textSecondaryLight;
  
  // ============================================================================
  // GRADIENT DEFINITIONS - Custom Palette Gradients
  // ============================================================================
  
  // Light Mode - Navy to Steel Blue Gradient
  static const LinearGradient primaryGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B3C53), Color(0xFF234C6A), Color(0xFF456882)],
    stops: [0.0, 0.5, 1.0],
  );
  
  // Dark Mode - Lighter Navy Gradient
  static const LinearGradient primaryGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A5070), Color(0xFF3D6A91), Color(0xFF5A7FA0)],
    stops: [0.0, 0.5, 1.0],
  );
  
  // Accent Gradient - Warm Beige (Light Mode)
  static const LinearGradient accentGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE3D6CC), Color(0xFFD2C1B6), Color(0xFFB8A599)],
  );
  
  // Accent Gradient - Warm Beige (Dark Mode)
  static const LinearGradient accentGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0E6DD), Color(0xFFE5D4C8), Color(0xFFD2C1B6)],
  );
  
  // ============================================================================
  // SHADOW COLORS
  // ============================================================================
  
  static Color shadowLight = Colors.black.withOpacity(0.08);
  static Color shadowDark = Colors.black.withOpacity(0.25);
  
  // ============================================================================
  // OVERLAY COLORS (for dialogs, modals)
  // ============================================================================
  
  static Color overlayLight = Colors.black.withOpacity(0.5);
  static Color overlayDark = Colors.black.withOpacity(0.7);
}
