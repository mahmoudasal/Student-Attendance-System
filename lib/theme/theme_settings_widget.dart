/// Theme Settings Widget
/// 
/// Provides a beautiful UI for theme selection with:
/// - Visual theme mode cards
/// - Smooth animations
/// - Arabic RTL support
/// - Accessibility features

import 'package:attendance_app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:attendance_app/theme/app_colors.dart';

class ThemeSettingsDialog extends StatelessWidget {
  final ThemeProvider themeProvider;
  
  const ThemeSettingsDialog({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: AppColors.primary(isDark),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'اختيار المظهر',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Theme Mode Cards
            _ThemeModeCard(
              icon: Icons.light_mode,
              title: 'وضع النهار',
              description: 'واجهة مضيئة للاستخدام النهاري',
              isSelected: themeProvider.themeMode == ThemeMode.light,
              onTap: () async {
                await themeProvider.setThemeMode(ThemeMode.light);
              },
            ),
            
            const SizedBox(height: 12),
            
            _ThemeModeCard(
              icon: Icons.dark_mode,
              title: 'الوضع الليلي',
              description: 'واجهة داكنة تريح العين في الإضاءة المنخفضة',
              isSelected: themeProvider.themeMode == ThemeMode.dark,
              onTap: () async {
                await themeProvider.setThemeMode(ThemeMode.dark);
              },
            ),
            
            const SizedBox(height: 12),
            
            _ThemeModeCard(
              icon: Icons.brightness_auto,
              title: 'تلقائي (النظام)',
              description: 'يتبع إعدادات نظام التشغيل',
              isSelected: themeProvider.themeMode == ThemeMode.system,
              onTap: () async {
                await themeProvider.setThemeMode(ThemeMode.system);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Info Text
            Text(
              'سيتم تطبيق المظهر على جميع الشاشات',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary(isDark),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _ThemeModeCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary(isDark).withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? AppColors.primary(isDark)
                : AppColors.dividerLight.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary(isDark)
                    : AppColors.primary(isDark).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : AppColors.primary(isDark),
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary(isDark),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            
            // Selection Indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary(isDark),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Quick Theme Toggle Button (for app bars, drawers, etc.)
class QuickThemeToggle extends StatelessWidget {
  final ThemeProvider themeProvider;
  
  const QuickThemeToggle({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          themeProvider.getThemeModeIcon(),
          key: ValueKey(themeProvider.themeMode),
        ),
      ),
      tooltip: themeProvider.getThemeModeName(),
      onPressed: () async {
        await themeProvider.toggleTheme();
      },
    );
  }
}

/// Floating Theme Toggle Button
class FloatingThemeToggle extends StatelessWidget {
  final ThemeProvider themeProvider;
  
  const FloatingThemeToggle({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return FloatingActionButton.small(
      heroTag: 'theme_toggle',
      backgroundColor: AppColors.primary(isDark),
      foregroundColor: Colors.white,
      onPressed: () async {
        await themeProvider.toggleTheme();
      },
      tooltip: themeProvider.getThemeModeName(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          themeProvider.getThemeModeIcon(),
          key: ValueKey(themeProvider.themeMode),
        ),
      ),
    );
  }
}
