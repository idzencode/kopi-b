import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/kopi_button.dart';
import '../../core/widgets/kopi_logo.dart';
import '../../core/widgets/kopi_progress_bar.dart';
import '../shared/models/kopi_models.dart';
import '../shared/state/kopi_app_state.dart';
import '../shared/widgets/product_visual_and_modals.dart';

/// Home Screen Kopi B (#kopiyangbaik) sesuai DESIGN_SYSTEM.md Bagian 6 & 7
/// Pusat aktivitas pemesanan dengan toggle Pick-up vs Delivery, kartu loyalty
/// B-Beans, promo mingguan, dan pilihan Best Seller.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.appState,
  });

  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    final bestSellers =
        appState.products.where((p) => p.isBestSeller).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 1. Top Botanical Brand Header + Sapaan + Kartu B-Beans
          SliverToBoxAdapter(
            child: _HomeHeroHeader(appState: appState),
          ),

          // 2. Toggle Pick-Up vs Delivery & Outlet Terdekat
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: _OrderModeOutletCard(appState: appState),
            ),
          ),

          // 3. Banner Promo Mingguan (#kopiyangbaik)
          SliverPadding(
            padding: const EdgeInsets.only(top: AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: _WeeklyPromoCarousel(appState: appState),
            ),
          ),

          // 4. Section Best Seller (Horizontal Cards)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Paling Favorit 🌱', style: AppTextStyles.heading1),
                      Text(
                        'Pilihan #kopiyangbaik paling dicintai minggu ini',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => appState.setTabIndex(1),
                    child: Text(
                      'Lihat Semua',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 242,
              child: ListView.separated(
                padding: AppSpacing.screenHorizontal,
                scrollDirection: Axis.horizontal,
                itemCount: bestSellers.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final product = bestSellers[index];
                  return _BestSellerCard(
                    product: product,
                    appState: appState,
                  );
                },
              ),
            ),
          ),

          // 5. Section Rekomendasi Hari Ini (Vertical List)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Diracik Segar Untukmu',
                style: AppTextStyles.heading1,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              110,
            ),
            sliver: SliverList.separated(
              itemCount: appState.products.take(6).length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final product = appState.products[index];
                return _HorizontalMenuTile(
                  product: product,
                  appState: appState,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeroHeader extends StatelessWidget {
  const _HomeHeroHeader({required this.appState});

  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    final progress =
        appState.bBeansPoints / appState.nextFreeCupTarget;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            Color(0xFF117E5A),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris Atas: Logo Kopi B + Sapaan + Notifikasi Promo
              Row(
                children: [
                  const KopiBLogo(
                    height: 44,
                    width: 108,
                    transparentBackground: true,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.softMintMist.withValues(alpha: 0.18),
                      borderRadius: AppSpacing.borderRadiusPill,
                      border: Border.all(
                        color: AppColors.softMintMist.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.eco_rounded,
                          size: 14,
                          color: AppColors.softMintMist,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          appState.memberTier,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.softMintMist,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Selamat sore, ${appState.userName.split(' ').first} 👋',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.background,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Siap menikmati seduhan #kopiyangbaik hari ini?',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.surfaceMint,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Kartu Loyalty Member "B-Beans"
              GestureDetector(
                onTap: () => appState.setTabIndex(3),
                child: Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMint,
                    borderRadius: AppSpacing.borderRadiusCardLg,
                    boxShadow: AppSpacing.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.workspace_premium_rounded,
                              color: AppColors.softMintMist,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${appState.bBeansPoints} B-Beans',
                                      style: AppTextStyles.heading1.copyWith(
                                        fontSize: 19,
                                        color: AppColors.neutralDark,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.softMintMist,
                                        borderRadius:
                                            AppSpacing.borderRadiusPill,
                                      ),
                                      child: Text(
                                        '${appState.vouchers.length} Voucher',
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.primaryDark,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${appState.nextFreeCupTarget - appState.bBeansPoints} B-Beans lagi menuju Free Cup Signature!',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      KopiProgressBar(
                        progress: progress,
                        activeColor: AppColors.primary,
                        trackColor: AppColors.surfaceMintTrack,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderModeOutletCard extends StatelessWidget {
  const _OrderModeOutletCard({required this.appState});

  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    final outlet = appState.selectedOutlet;

    return Container(
      padding: AppSpacing.cardPaddingCompact,
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: AppSpacing.borderRadiusCardLg,
        border: AppSpacing.subtleBorder,
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        children: [
          // Toggle Pick Up vs Delivery
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surfaceMintTrack,
              borderRadius: AppSpacing.borderRadiusPill,
            ),
            child: Row(
              children: OrderMode.values.map((mode) {
                final isSelected = appState.orderMode == mode;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => appState.setOrderMode(mode),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: AppSpacing.borderRadiusPill,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            mode.icon,
                            size: 17,
                            color: isSelected
                                ? AppColors.background
                                : AppColors.primaryDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            mode.title,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isSelected
                                  ? AppColors.background
                                  : AppColors.primaryDark,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Detail Outlet Terpilih
          InkWell(
            borderRadius: AppSpacing.borderRadiusMd,
            onTap: () => showOutletSelectorSheet(
              context: context,
              appState: appState,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 4,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMint,
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                outlet.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.heading2.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.softMintMist,
                                borderRadius: AppSpacing.borderRadiusPill,
                              ),
                              child: Text(
                                '${outlet.distanceKm} km',
                                style: AppTextStyles.caption.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          appState.orderMode == OrderMode.pickUp
                              ? 'Siap diambil dalam ~${outlet.prepMinutes} menit • Tanpa antre'
                              : 'Antar ke: ${appState.deliveryAddress}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Ubah',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyPromoCarousel extends StatelessWidget {
  const _WeeklyPromoCarousel({required this.appState});

  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 152,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.screenHorizontal,
        children: [
          _PromoBannerCard(
            badge: 'PROMO SPESIAL',
            title: 'Aren & Oat Series\nHemat 30% Hari Ini',
            subtitle: 'Gunakan kode KOPIYANGBAIK saat checkout',
            backgroundColor: AppColors.primary,
            textColor: AppColors.background,
            buttonVariant: KopiButtonVariant.secondary,
            onTap: () => appState.setTabIndex(1),
          ),
          const SizedBox(width: AppSpacing.md),
          _PromoBannerCard(
            badge: 'ECO MOVEMENT 🌱',
            title: 'Bawa Tumbler Sendiri\nPotongan Rp 5.000',
            subtitle: 'Kurangi jejak plastik di seluruh outlet Kopi B',
            backgroundColor: AppColors.surfaceMint,
            textColor: AppColors.neutralDark,
            buttonVariant: KopiButtonVariant.inverted,
            onTap: () {
              appState.toggleBringOwnTumbler(true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  content: Text('Mode Eco-Tumbler (-Rp 5.000) diaktifkan! 🌱'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PromoBannerCard extends StatelessWidget {
  const _PromoBannerCard({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.textColor,
    required this.buttonVariant,
    required this.onTap,
  });

  final String badge;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;
  final KopiButtonVariant buttonVariant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppSpacing.borderRadiusCardLg,
        border: AppSpacing.subtleBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  badge,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutralDark,
                  ),
                ),
              ),
              Icon(
                Icons.local_cafe_rounded,
                color: textColor.withValues(alpha: 0.25),
                size: 22,
              ),
            ],
          ),
          Text(
            title,
            style: AppTextStyles.heading2.copyWith(
              color: textColor,
              height: 1.25,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              KopiButton(
                label: 'Klaim',
                variant: buttonVariant,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                onPressed: onTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BestSellerCard extends StatelessWidget {
  const _BestSellerCard({
    required this.product,
    required this.appState,
  });

  final CoffeeProduct product;
  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDrinkCustomizationSheet(
        context: context,
        product: product,
        appState: appState,
      ),
      child: Container(
        width: 172,
        padding: AppSpacing.cardPaddingCompact,
        decoration: BoxDecoration(
          color: AppColors.surfaceMint,
          borderRadius: AppSpacing.borderRadiusCardLg,
          border: AppSpacing.subtleBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: KopiProductVisual(product: product, size: 96),
                ),
                if (product.badgeText != null)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softMintMist,
                        borderRadius: AppSpacing.borderRadiusPill,
                      ),
                      child: Text(
                        product.badgeText!,
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
            const SizedBox(height: AppSpacing.sm),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.heading2.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 2),
            Text(
              '${product.calories} kkal • ★ ${product.rating}',
              style: AppTextStyles.caption,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.originalPrice != null)
                      Text(
                        formatRupiah(product.originalPrice!),
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      formatRupiah(product.price),
                      style: AppTextStyles.heading2.copyWith(
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                KopiCircleActionButton(
                  icon: Icons.add_rounded,
                  size: 34,
                  onTap: () => showDrinkCustomizationSheet(
                    context: context,
                    product: product,
                    appState: appState,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalMenuTile extends StatelessWidget {
  const _HorizontalMenuTile({
    required this.product,
    required this.appState,
  });

  final CoffeeProduct product;
  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppSpacing.borderRadiusCard,
      onTap: () => showDrinkCustomizationSheet(
        context: context,
        product: product,
        appState: appState,
      ),
      child: Container(
        padding: AppSpacing.cardPaddingCompact,
        decoration: BoxDecoration(
          color: AppColors.surfaceMint,
          borderRadius: AppSpacing.borderRadiusCard,
          border: AppSpacing.subtleBorder,
        ),
        child: Row(
          children: [
            KopiProductVisual(product: product, size: 78),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.badgeText != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softMintMist,
                        borderRadius: AppSpacing.borderRadiusPill,
                      ),
                      child: Text(
                        product.badgeText!,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutralDark,
                        ),
                      ),
                    ),
                  Text(product.name, style: AppTextStyles.heading2),
                  const SizedBox(height: 2),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        formatRupiah(product.price),
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.primary,
                          fontSize: 15,
                        ),
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          formatRupiah(product.originalPrice!),
                          style: AppTextStyles.caption.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            KopiCircleActionButton(
              icon: Icons.add_rounded,
              size: 38,
              onTap: () => showDrinkCustomizationSheet(
                context: context,
                product: product,
                appState: appState,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

