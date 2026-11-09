import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Widget Resmi Logo "Kopi B" (#kopiyangbaik)
/// Menggunakan asset gambar resmi `assets/images/logo.png`.
class KopiBLogo extends StatelessWidget {
  const KopiBLogo({
    super.key,
    this.width,
    this.height,
    this.transparentBackground = true,
    this.showContainer = false,
    this.containerColor = AppColors.primary,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.fit = BoxFit.contain,
  });

  final double? width;
  final double? height;
  final bool transparentBackground;
  final bool showContainer;
  final Color containerColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry padding;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      'assets/images/logo.png',
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.high,
    );

    if (!showContainer && padding == EdgeInsets.zero) {
      return image;
    }

    return Container(
      padding: padding,
      decoration: showContainer
          ? BoxDecoration(
              color: containerColor,
              borderRadius: borderRadius ?? AppSpacing.borderRadiusMd,
            )
          : null,
      child: image,
    );
  }
}
