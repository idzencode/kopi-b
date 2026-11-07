import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// 4 Varian Tombol Standar sesuai UI Kit Board Kopi B:
/// - [KopiButtonVariant.primary]: #0D6B4C Deep Forest Green, teks putih
/// - [KopiButtonVariant.secondary]: #E2F5F2 Ice Mint Container, teks #05452E
/// - [KopiButtonVariant.inverted]: #011E13 Obsidian Evergreen, teks putih
/// - [KopiButtonVariant.outlined]: Transparan/Mint lembut, border #7CBCA4
enum KopiButtonVariant {
  primary,
  secondary,
  inverted,
  outlined,
}

class KopiButton extends StatelessWidget {
  const KopiButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = KopiButtonVariant.primary,
    this.icon,
    this.isFullWidth = false,
    this.isPill = false,
    this.height = 46,
    this.padding,
  });

  final String label;
  final VoidCallback? onPressed;
  final KopiButtonVariant variant;
  final IconData? icon;
  final bool isFullWidth;
  final bool isPill;
  final double height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        isPill ? AppSpacing.borderRadiusPill : AppSpacing.borderRadiusMd;

    final (Color bg, Color fg, BorderSide? border) = switch (variant) {
      KopiButtonVariant.primary => (
          AppColors.primary,
          AppColors.background,
          null,
        ),
      KopiButtonVariant.secondary => (
          AppColors.surfaceMintTrack,
          AppColors.primaryDark,
          null,
        ),
      KopiButtonVariant.inverted => (
          AppColors.neutralDark,
          AppColors.background,
          null,
        ),
      KopiButtonVariant.outlined => (
          Colors.transparent,
          AppColors.primaryDark,
          const BorderSide(color: AppColors.textSecondary, width: 1.3),
        ),
    };

    final child = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: fg,
              fontWeight: variant == KopiButtonVariant.primary
                  ? FontWeight.w600
                  : FontWeight.w500,
            ),
          ),
        ),
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: Material(
        color: onPressed == null ? bg.withValues(alpha: 0.5) : bg,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: border ?? BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Tombol Ikon Lingkaran Cepat (Circular Quick Action Button)
/// Sesuai kanan bawah UI Kit Board (#0D6B4C untuk aksi standar, #C62828 untuk hapus)
class KopiCircleActionButton extends StatelessWidget {
  const KopiCircleActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
    this.size = 42,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: isDestructive ? AppColors.error : AppColors.primary,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: AppColors.background,
            size: size * 0.46,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip, child: button);
    }
    return button;
  }
}

/// Square Soft Icon Action Button sesuai bawah tengah UI Kit Board
class KopiSquareIconButton extends StatelessWidget {
  const KopiSquareIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 46,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.softForestTile,
      borderRadius: AppSpacing.borderRadiusMd,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: AppColors.sageSlate,
            size: 20,
          ),
        ),
      ),
    );
  }
}

