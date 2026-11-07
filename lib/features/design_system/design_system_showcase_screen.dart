import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/kopi_button.dart';
import '../../core/widgets/kopi_logo.dart';
import '../../core/widgets/kopi_progress_bar.dart';
import '../../core/widgets/kopi_search_bar.dart';

/// Interactive Design System UI Kit Board ("Kopi B" #kopiyangbaik)
/// Mereplikasi secara presisi seluruh elemen visual pada gambar referensi
/// Design System Board agar developer/desainer dapat melihat komponen live.
class DesignSystemShowcaseScreen extends StatelessWidget {
  const DesignSystemShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC8EBD9),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        title: Row(
          children: [
            const KopiBLogo(
              height: 30,
              width: 72,
              transparentBackground: true,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Design System UI Kit',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.background,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // ─── 1. Color Palette Cards with Tonal Strips ──────────────────────
          Text(
            '1. Color Palette System',
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            children: [
              Expanded(
                child: _ColorSwatchCard(
                  title: 'Primary',
                  hexCode: '#0D6B4C',
                  mainColor: AppColors.primary,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ColorSwatchCard(
                  title: 'Secondary',
                  hexCode: '#28E5A7',
                  mainColor: AppColors.secondary,
                  textColor: AppColors.neutralDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Row(
            children: [
              Expanded(
                child: _ColorSwatchCard(
                  title: 'Tertiary',
                  hexCode: '#7CBCA4',
                  mainColor: AppColors.tertiary,
                  textColor: AppColors.neutralDark,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ColorSwatchCard(
                  title: 'Neutral',
                  hexCode: '#011E13',
                  mainColor: AppColors.neutralDark,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // ─── 2. Typography Cards (Plus Jakarta Sans) ───────────────────────
          Text(
            '2. Typography Hierarchy (Plus Jakarta Sans)',
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Row(
            children: [
              Expanded(
                child: _TypographyShowcaseCard(
                  role: 'Headline',
                  sampleWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _TypographyShowcaseCard(
                  role: 'Body',
                  sampleWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _TypographyShowcaseCard(
                  role: 'Label',
                  sampleWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // ─── 3. Button Variants (Primary, Secondary, Inverted, Outlined) ───
          Text(
            '3. Button Variants',
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.surfaceMint,
              borderRadius: AppSpacing.borderRadiusCardLg,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: KopiButton(
                        label: 'Primary',
                        variant: KopiButtonVariant.primary,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: KopiButton(
                        label: 'Secondary',
                        variant: KopiButtonVariant.secondary,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: KopiButton(
                        label: 'Inverted',
                        variant: KopiButtonVariant.inverted,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: KopiButton(
                        label: 'Outlined',
                        variant: KopiButtonVariant.outlined,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ─── 4. Search Input & Progress Bars ───────────────────────────────
          Text(
            '4. Search Input & Progress Indicators',
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.surfaceMint,
              borderRadius: AppSpacing.borderRadiusCardLg,
            ),
            child: const Column(
              children: [
                KopiSearchBar(hintText: 'Search'),
                SizedBox(height: AppSpacing.lg),
                KopiProgressBar(progress: 0.70),
                SizedBox(height: AppSpacing.md),
                KopiProgressBar(progress: 0.85),
                SizedBox(height: AppSpacing.md),
                KopiProgressBar(progress: 0.55),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // ─── 5. Action Buttons & FAB Variants ──────────────────────────────
          Text(
            '5. Icon Actions & Quick Buttons',
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.surfaceMint,
              borderRadius: AppSpacing.borderRadiusCardLg,
            ),
            child: Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceAround,
              children: [
                KopiSquareIconButton(
                  icon: Icons.edit_outlined,
                  onTap: () {},
                ),
                KopiButton(
                  label: 'Label',
                  icon: Icons.edit_outlined,
                  onPressed: () {},
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KopiCircleActionButton(
                      icon: Icons.auto_fix_high_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    KopiCircleActionButton(
                      icon: Icons.category_outlined,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    KopiCircleActionButton(
                      icon: Icons.local_offer_outlined,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    KopiCircleActionButton(
                      icon: Icons.delete_outline_rounded,
                      isDestructive: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _ColorSwatchCard extends StatelessWidget {
  const _ColorSwatchCard({
    required this.title,
    required this.hexCode,
    required this.mainColor,
    required this.textColor,
  });

  final String title;
  final String hexCode;
  final Color mainColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(mainColor);
    final tones = List.generate(11, (i) {
      final lightness = (i / 10.0).clamp(0.04, 0.98);
      return hsl.withLightness(lightness).toColor();
    });

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: AppSpacing.borderRadiusCard,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  hexCode,
                  style: AppTextStyles.caption.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36,
            child: Row(
              children: tones
                  .map(
                    (c) => Expanded(
                      child: ColoredBox(
                        color: c,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypographyShowcaseCard extends StatelessWidget {
  const _TypographyShowcaseCard({
    required this.role,
    required this.sampleWeight,
  });

  final String role;
  final FontWeight sampleWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMint,
        borderRadius: AppSpacing.borderRadiusCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(role, style: AppTextStyles.caption),
          const Text(
            'Plus Jakarta Sans',
            style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Aa',
              style: AppTextStyles.display.copyWith(
                fontSize: 38,
                fontWeight: sampleWeight,
                color: AppColors.neutralDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

