import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Progress Bar Kopi B sesuai bagian tengah UI Kit Board
class KopiProgressBar extends StatelessWidget {
  const KopiProgressBar({
    super.key,
    required this.progress,
    this.height = 6.0,
    this.activeColor = AppColors.primary,
    this.trackColor = AppColors.surfaceMintTrack,
  });

  /// Nilai antara 0.0 hingga 1.0
  final double progress;
  final double height;
  final Color activeColor;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusPill,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: [
            Container(color: trackColor),
            FractionallySizedBox(
              widthFactor: clamped,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

