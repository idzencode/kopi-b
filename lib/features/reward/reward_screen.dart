import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/kopi_button.dart';
import '../../core/widgets/kopi_progress_bar.dart';
import '../shared/models/kopi_models.dart';
import '../shared/state/kopi_app_state.dart';

/// Reward Screen Kopi B (#kopiyangbaik) sesuai DESIGN_SYSTEM.md Bagian 6 & 7
/// Menampilkan poin loyalitas B-Beans, Stamp Card 8-Cup, dan Voucher Diskon.
class RewardScreen extends StatelessWidget {
  const RewardScreen({
    super.key,
    required this.appState,
  });

  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    final progress =
        appState.bBeansPoints / appState.nextFreeCupTarget;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Reward & B-Beans', style: AppTextStyles.heading1),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          110,
        ),
        children: [
          // 1. Kartu Hero B-Beans Loyalty
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryDark,
                  AppColors.primary,
                ],
              ),
              borderRadius: AppSpacing.borderRadiusCardLg,
              boxShadow: AppSpacing.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softMintMist,
                        borderRadius: AppSpacing.borderRadiusPill,
                      ),
                      child: Text(
                        appState.memberTier.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.neutralDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.eco_rounded,
                      color: AppColors.secondary,
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${appState.bBeansPoints}',
                      style: AppTextStyles.display.copyWith(
                        color: AppColors.background,
                        fontSize: 34,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        '/ ${appState.nextFreeCupTarget} B-Beans',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.softMintMist,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                KopiProgressBar(
                  progress: progress,
                  height: 8,
                  activeColor: AppColors.secondary,
                  trackColor: AppColors.primaryDark,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Kumpulkan ${appState.nextFreeCupTarget - appState.bBeansPoints} B-Beans lagi untuk klaim 1 Cup Kopi B Gratis!',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.surfaceMint,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 2. Botanical Stamp Card (8 Cup = 1 Gratis)
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.surfaceMint,
              borderRadius: AppSpacing.borderRadiusCardLg,
              border: AppSpacing.subtleBorder,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stamp Card #kopiyangbaik',
                      style: AppTextStyles.heading2,
                    ),
                    Text(
                      '${appState.stampCount}/8 Cup',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Dapatkan 1 stamp setiap pembelian 1 cup minuman apa saja.',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(8, (index) {
                    final filled = index < appState.stampCount;
                    final isRewardSlot = index == 7;
                    return Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: filled
                            ? AppColors.primary
                            : AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isRewardSlot
                              ? AppColors.secondaryDark
                              : AppColors.sageSlate,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        isRewardSlot
                            ? Icons.card_giftcard_rounded
                            : Icons.local_cafe_rounded,
                        size: 17,
                        color: filled
                            ? AppColors.background
                            : AppColors.tertiary,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 3. Daftar Voucher Promo & Penukaran B-Beans
          Text('Voucher & Penukaran Kopi', style: AppTextStyles.heading1),
          const SizedBox(height: AppSpacing.sm),
          ...appState.vouchers.map((voucher) {
            final isApplied = appState.appliedVoucher?.id == voucher.id;
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: isApplied
                    ? AppColors.surfaceMint
                    : AppColors.surfaceSoft,
                borderRadius: AppSpacing.borderRadiusCard,
                border: Border.all(
                  color: isApplied ? AppColors.primary : AppColors.sageSlate,
                  width: isApplied ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softMintMist,
                          borderRadius: AppSpacing.borderRadiusPill,
                        ),
                        child: Text(
                          voucher.beansCost > 0
                              ? 'TUKAR ${voucher.beansCost} BEANS'
                              : voucher.code,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.neutralDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Text(
                        voucher.validUntil,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(voucher.title, style: AppTextStyles.heading2),
                  const SizedBox(height: 2),
                  Text(voucher.subtitle, style: AppTextStyles.body),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hemat ${formatRupiah(voucher.discountAmount)}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      KopiButton(
                        label: isApplied ? 'Terpasang ✓' : 'Pakai Voucher',
                        variant: isApplied
                            ? KopiButtonVariant.secondary
                            : KopiButtonVariant.primary,
                        height: 36,
                        onPressed: () {
                          appState.applyVoucher(isApplied ? null : voucher);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

