/// App Theme Configuration
/// 
/// Provides complete light and dark theme definitions with:
/// - Material Design 3 principles
/// - WCAG AA accessibility compliance
/// - Smooth transitions between themes
/// - RTL (Arabic) language support

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  // ============================================================================
  // LIGHT THEME
  // ============================================================================
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      primaryContainer: AppColors.primaryPale,
      secondary: AppColors.secondaryLight,
      secondaryContainer: AppColors.secondaryPale,
      tertiary: AppColors.accentLight,
      tertiaryContainer: AppColors.accentPale,
      error: AppColors.errorLight,
      errorContainer: const Color(0xFFFFEBEE),
      background: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
      onPrimary: AppColors.textOnPrimaryLight,
      onSecondary: Colors.white,
      onTertiary: Colors.white,
      onError: Colors.white,
      onBackground: AppColors.textPrimaryLight,
      onSurface: AppColors.textPrimaryLight,
      outline: AppColors.dividerLight,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: AppColors.backgroundLight,
    
    // App Bar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.primaryLight,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: const IconThemeData(color: Colors.white, size: 24),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: AppColors.shadowLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.cardLight,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.dividerLight,
        disabledForegroundColor: AppColors.textTertiaryLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        maximumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: BorderSide(color: AppColors.primaryLight, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.primaryPale,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      
      // Border Styles
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.errorLight, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.errorLight, width: 2),
      ),
      
      // Icon Colors
      prefixIconColor: AppColors.primaryLight,
      suffixIconColor: AppColors.primaryLight,
      
      // Label & Hint Styles
      labelStyle: TextStyle(
        color: AppColors.textSecondaryLight,
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        color: AppColors.textTertiaryLight,
        fontSize: 14,
      ),
      errorStyle: TextStyle(
        color: AppColors.errorLight,
        fontSize: 12,
      ),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textSecondaryLight,
      selectedIconTheme: const IconThemeData(size: 28),
      unselectedIconTheme: const IconThemeData(size: 24),
      selectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    
    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryLight,
      unselectedLabelColor: AppColors.textSecondaryLight,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primaryLight, width: 3),
      ),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Icon Theme
    iconTheme: IconThemeData(
      color: AppColors.primaryLight,
      size: 24,
    ),
    
    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
      space: 1,
    ),
    
    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.textSecondaryLight,
        fontSize: 16,
      ),
    ),
    
    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimaryLight,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),
    
    // Data Table Theme
    dataTableTheme: DataTableThemeData(
      headingTextStyle: TextStyle(
        color: AppColors.primaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      dataTextStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 14,
      ),
      dividerThickness: 1,
      columnSpacing: 24,
      horizontalMargin: 16,
    ),
  );
  
  // ============================================================================
  // DARK THEME
  // ============================================================================
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDarkMode,
      primaryContainer: AppColors.primaryDarkModePale,
      secondary: AppColors.secondaryDarkMode,
      secondaryContainer: AppColors.secondaryDarkModePale,
      tertiary: AppColors.accentDarkMode,
      tertiaryContainer: AppColors.accentDarkModePale,
      error: AppColors.errorDark,
      errorContainer: const Color(0xFF3D1F1F),
      background: AppColors.backgroundDark,
      surface: AppColors.surfaceDark,
      onPrimary: AppColors.textOnPrimaryDark,
      onSecondary: Colors.black,
      onTertiary: Colors.black,
      onError: Colors.black,
      onBackground: AppColors.textPrimaryDark,
      onSurface: AppColors.textPrimaryDark,
      outline: AppColors.dividerDark,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: AppColors.backgroundDark,
    
    // App Bar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: AppColors.primaryDarkMode, size: 24),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shadowColor: AppColors.shadowDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.cardDark,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: AppColors.primaryDarkMode,
        foregroundColor: AppColors.textOnPrimaryDark,
        disabledBackgroundColor: AppColors.dividerDark,
        disabledForegroundColor: AppColors.textTertiaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        maximumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryDarkMode,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryDarkMode,
        side: BorderSide(color: AppColors.primaryDarkMode, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        minimumSize: const Size(double.infinity, 56),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.primaryDarkModePale,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      
      // Border Styles
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.primaryDarkMode, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.errorDark, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.errorDark, width: 2),
      ),
      
      // Icon Colors
      prefixIconColor: AppColors.primaryDarkMode,
      suffixIconColor: AppColors.primaryDarkMode,
      
      // Label & Hint Styles
      labelStyle: TextStyle(
        color: AppColors.textSecondaryDark,
        fontSize: 14,
      ),
      hintStyle: TextStyle(
        color: AppColors.textTertiaryDark,
        fontSize: 14,
      ),
      errorStyle: TextStyle(
        color: AppColors.errorDark,
        fontSize: 12,
      ),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryDarkMode,
      unselectedItemColor: AppColors.textSecondaryDark,
      selectedIconTheme: const IconThemeData(size: 28),
      unselectedIconTheme: const IconThemeData(size: 24),
      selectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    
    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryDarkMode,
      unselectedLabelColor: AppColors.textSecondaryDark,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primaryDarkMode, width: 3),
      ),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Icon Theme
    iconTheme: IconThemeData(
      color: AppColors.primaryDarkMode,
      size: 24,
    ),
    
    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
      space: 1,
    ),
    
    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.cardDark,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.textSecondaryDark,
        fontSize: 16,
      ),
    ),
    
    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.cardDark,
      contentTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),
    
    // Data Table Theme
    dataTableTheme: DataTableThemeData(
      headingTextStyle: TextStyle(
        color: AppColors.primaryDarkMode,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      dataTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 14,
      ),
      dividerThickness: 1,
      columnSpacing: 24,
      horizontalMargin: 16,
    ),
  );
}
