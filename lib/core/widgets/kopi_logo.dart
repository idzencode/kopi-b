import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Widget Resmi Logo "Kopi B" (#kopiyangbaik)
///
/// Secara default menggunakan [transparentBackground] = `true` yang mengekstrak
/// elemen putih logo secara presisi (menghilangkan kotak background hijau solid
/// dari file webp) sehingga dapat menyatu mulus di atas gradien gelombang
/// Splash Screen maupun header.
class KopiBLogo extends StatelessWidget {
  const KopiBLogo({
    super.key,
    this.width,
    this.height = 80,
    this.transparentBackground = true,
    this.showContainer = false,
    this.containerColor = AppColors.primary,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.fit = BoxFit.contain,
  });

  final double? width;
  final double? height;

  /// Jika true, menghilangkan warna hijau solid pada gambar asli sehingga hanya
  /// menyisakan grafis & tipografi putih murni dengan anti-aliasing halus.
  final bool transparentBackground;

  /// Jika true, membungkus logo dalam container berwarna [containerColor].
  final bool showContainer;
  final Color containerColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry padding;
  final BoxFit fit;

  /// Matrix ekstraksi kanal putih dari background #0D6B4C (R≈13, G≈107, B≈76):
  /// Piksel background memiliki R ≈ 13 -> Alpha = 1.09 * 13 - 19 = -4.8 -> 0 (transparan).
  /// Piksel logo putih memiliki R = 255 -> Alpha = 255 (putih solid murni).
  static const List<double> _whiteLogoExtractMatrix = <double>[
    0, 0, 0, 0, 255, // R' = 255 (Putih)
    0, 0, 0, 0, 255, // G' = 255 (Putih)
    0, 0, 0, 0, 255, // B' = 255 (Putih)
    1.09, 0, 0, 0, -19, // A' = 1.09 * R - 19 (Halus & bebas kotak background)
  ];

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      'assets/images/logo_kopi_b.webp',
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.high,
    );

    if (transparentBackground) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix(_whiteLogoExtractMatrix),
        child: image,
      );
    }

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
