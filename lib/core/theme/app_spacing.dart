import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Standar Layout, Spacing, Corner Radius, dan Elevation "Kopi B"
/// Acuan: DESIGN_SYSTEM.md Bagian 4
abstract final class AppSpacing {
  // ─── Viewport Reference ────────────────────────────────────────────────────
  static const double designViewportWidth = 390.0;

  // ─── Spacing Scale (Base 4pt / 8pt) ────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // ─── Standard Paddings ─────────────────────────────────────────────────────
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets screenPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(md);

  // ─── Corner Radius Tokens ──────────────────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusCard = 16.0;
  static const double radiusCardLg = 20.0;
  static const double radiusPill = 9999.0;

  static final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusCard = BorderRadius.circular(radiusCard);
  static final BorderRadius borderRadiusCardLg = BorderRadius.circular(radiusCardLg);
  static final BorderRadius borderRadiusPill = BorderRadius.circular(radiusPill);

  // ─── Elevation / Botanical Soft Shadows ────────────────────────────────────
  /// Soft diffused drop-shadow rgba(13, 107, 76, 0.08)
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color.fromRGBO(13, 107, 76, 0.08),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Floating Cart & Bottom Navigation shadow
  static const List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Color.fromRGBO(1, 30, 19, 0.12),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Subtle border untuk kartu di atas background putih/mint
  static Border subtleBorder = Border.all(
    color: AppColors.sageSlate.withValues(alpha: 0.35),
    width: 1.0,
  );
}

