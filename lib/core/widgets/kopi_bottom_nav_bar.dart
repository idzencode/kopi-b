import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Bottom Navigation Bar 5-Tab Persisten sesuai DESIGN_SYSTEM.md Bagian 5
/// dan gaya pill indicator hijau (#0D6B4C) pada UI Kit Board.
class KopiBottomNavBar extends StatelessWidget {
  const KopiBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.activeOrderCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int activeOrderCount;

  static const List<_NavDestination> _destinations = [
    _NavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavDestination(
      label: 'Menu',
      icon: Icons.local_cafe_outlined,
      activeIcon: Icons.local_cafe_rounded,
    ),
    _NavDestination(
      label: 'Order',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
    ),
    _NavDestination(
      label: 'Reward',
      icon: Icons.workspace_premium_outlined,
      activeIcon: Icons.workspace_premium_rounded,
    ),
    _NavDestination(
      label: 'Akun',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: AppSpacing.floatingShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceMintTrack.withValues(alpha: 0.75),
              borderRadius: AppSpacing.borderRadiusPill,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_destinations.length, (index) {
                final item = _destinations[index];
                final isSelected = index == currentIndex;
                final showBadge = index == 2 && activeOrderCount > 0;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOutCubic,
                              width: isSelected ? 40 : 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isSelected ? item.activeIcon : item.icon,
                                size: 20,
                                color: isSelected
                                    ? AppColors.background
                                    : AppColors.primaryDark,
                              ),
                            ),
                            if (showBadge)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$activeOrderCount',
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.neutralDark,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

