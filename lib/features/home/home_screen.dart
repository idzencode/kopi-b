import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/kopi_button.dart';
import '../auth/auth_onboarding_screens.dart';
import '../shared/models/kopi_models.dart';
import '../shared/state/kopi_app_state.dart';
import '../shared/widgets/product_visual_and_modals.dart';

/// Home Screen Kopi B (#kopiyangbaik)
/// Mengadopsi tata letak modern Fore Coffee dengan sentuhan artisanal botanical:
/// 1. Full-width Hero Carousel (Aksesoris Tumbler & Promo #kopiyangbaik) + Notifikasi Bell
/// 2. Floating Welcome Card ("Welcome to Kopi B!" + "Login Sekarang" / Member Status)
/// 3. Dua Pilihan Utama: "Pick Up" (Ambil di store tanpa antri) & "Delivery" (Garansi tepat waktu)
/// 4. Section 2x2 Grid: "Spesial Untukmu di Kopi B" (My Kopi B Plan, Kopi B Essentials, Katering, Stamp Game)
/// 5. Rekomendasi Menu Paling Favorit (#kopiyangbaik Best Sellers)
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.appState,
  });

  final KopiAppState appState;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _openAuthFlow() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (routeCtx) => WelcomeOnboardingScreen(
          onSkipToHome: () => Navigator.of(routeCtx).pop(),
          onLoginSuccess: (phone) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                content: Text('Selamat datang kembali di Kopi B ($phone)!'),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bestSellers =
        widget.appState.products.where((p) => p.isBestSeller).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── 1. HERO CAROUSEL + FLOATING BELL ──────────────────────────────
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner Carousel
                SizedBox(
                  height: 330,
                  child: PageView(
                    controller: _bannerController,
                    onPageChanged: (i) =>
                        setState(() => _currentBannerIndex = i),
                    children: const [
                      _TumblerAccessoriesBanner(),
                      _SignatureCoffeePromoBanner(),
                      _EcoTumblerMovementBanner(),
                    ],
                  ),
                ),

                // Carousel Dots Indicator
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 42,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final active = i == _currentBannerIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primary
                              : Colors.black.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),

                // Floating Notification Bell Button di Kanan Atas
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 10,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Tidak ada notifikasi baru hari ini 🌱',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.neutralDark.withValues(alpha: 0.72),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x24000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          Positioned(
                            top: 9,
                            right: 10,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE11D23),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ─── 2. FLOATING WELCOME CARD ────────────────────────────────
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: -32,
                  child: _FloatingWelcomeCard(
                    appState: widget.appState,
                    onLoginTap: _openAuthFlow,
                  ),
                ),
              ],
            ),
          ),

          // Spacing kompensasi kartu floating
          const SliverToBoxAdapter(
            child: SizedBox(height: 52),
          ),

          // ─── 3. SECTION "Pesan Kopi B Sekarang?" ────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesan Kopi B Sekarang?',
                    style: AppTextStyles.heading1.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutralDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Card Pick Up
                      Expanded(
                        child: _OrderModeCard(
                          title: 'Pick Up',
                          subtitle: 'Ambil di store tanpa antri',
                          titleColor: AppColors.primary,
                          borderColor: AppColors.primary.withValues(alpha: 0.4),
                          backgroundColor: const Color(0xFFF7FCF9),
                          tagLabel: widget.appState.orderMode == OrderMode.pickUp
                              ? 'Aktif'
                              : null,
                          illustration: const _BaristaIllustration(),
                          onTap: () {
                            widget.appState.setOrderMode(OrderMode.pickUp);
                            widget.appState.setTabIndex(1); // Ke Menu
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Card Delivery
                      Expanded(
                        child: _OrderModeCard(
                          title: 'Delivery',
                          subtitle: 'Garansi tepat waktu, dijamin!',
                          titleColor: const Color(0xFF8C5828),
                          borderColor: const Color(0xFFE8D4BE),
                          backgroundColor: const Color(0xFFFDFBF7),
                          tagLabel:
                              widget.appState.orderMode == OrderMode.delivery
                                  ? 'Aktif'
                                  : null,
                          illustration: const _CourierIllustration(),
                          onTap: () {
                            widget.appState.setOrderMode(OrderMode.delivery);
                            widget.appState.setTabIndex(1); // Ke Menu
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── 4. SECTION "Spesial Untukmu di Kopi B" ─────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              28,
              AppSpacing.lg,
              12,
            ),
            sliver: SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spesial Untukmu di Kopi B',
                        style: AppTextStyles.heading1.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.neutralDark,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Grid 2x2 Feature Cards
                      Row(
                        children: [
                          Expanded(
                            child: _SpecialFeatureCard(
                              title: 'My Kopi B Plan',
                              subtitle: 'Berlangganan jauh lebih untung',
                              iconPainter: const _FeatureDoodlePainter(
                                type: _DoodleType.cupPlan,
                              ),
                              onTap: () {
                                widget.appState.setTabIndex(3); // Reward
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SpecialFeatureCard(
                              title: 'Kopi B Essentials',
                              subtitle: 'Bawa minumanmu dengan gaya baru',
                              badgeText: 'Baru',
                              iconPainter: const _FeatureDoodlePainter(
                                type: _DoodleType.tumbler,
                              ),
                              onTap: () {
                                widget.appState.toggleBringOwnTumbler(true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: AppColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'Eco-Tumbler aktif! Dapatkan diskon Rp 5.000 🌱',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _SpecialFeatureCard(
                              title: 'Katering & Kantor',
                              subtitle: 'Pesan banyak lebih hemat & praktis',
                              iconPainter: const _FeatureDoodlePainter(
                                type: _DoodleType.groupOrder,
                              ),
                              onTap: () {
                                widget.appState.setTabIndex(1);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SpecialFeatureCard(
                              title: 'Stamp & Rewards',
                              subtitle: 'Kumpulkan stamp untuk kopi gratis',
                              iconPainter: const _FeatureDoodlePainter(
                                type: _DoodleType.stampReward,
                              ),
                              onTap: () {
                                widget.appState.setTabIndex(3); // Reward
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Floating Circular Sticker "NEW! #kopiyangbaik" di Kanan
                  Positioned(
                    right: 4,
                    bottom: 74,
                    child: _FloatingArtisanalBadge(
                      onTap: () => widget.appState.setTabIndex(1),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── 5. BEST SELLER SHORTCUT CAROUSEL ──────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              20,
              AppSpacing.lg,
              12,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Paling Favorit Hari Ini 🌱',
                    style: AppTextStyles.heading1.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => widget.appState.setTabIndex(1),
                    child: Text(
                      'Lihat Semua',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                scrollDirection: Axis.horizontal,
                itemCount: bestSellers.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = bestSellers[index];
                  return _CompactBestSellerCard(
                    product: product,
                    appState: widget.appState,
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 110),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// 1. HERO BANNERS (Aksesoris Tumbler Pastel & Promo Kopi B)
// ═════════════════════════════════════════════════════════════════════════════
class _TumblerAccessoriesBanner extends StatelessWidget {
  const _TumblerAccessoriesBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8ECEB),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Studio Split (Kiri teks, Kanan grid foto tumbler)
          CustomPaint(
            painter: _TumblerGridStudioPainter(),
          ),

          // Teks Penawaran Khas Banner Fore/Kopi B
          Positioned(
            left: 20,
            top: 78,
            width: 175,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E2421),
                      height: 1.25,
                    ),
                    children: [
                      const TextSpan(text: 'Tambah '),
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(0, -6),
                          child: const Text(
                            'Rp',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2421),
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: '10'),
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(0, -6),
                          child: const Text(
                            'K',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2421),
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: '\ndapat '),
                      const TextSpan(
                        text: 'extra',
                        style: TextStyle(
                          color: Color(0xFF8B2B1B),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const TextSpan(
                        text: ' aksesoris\ntumbler Kopi B',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'dengan pembelian 1 tumbler Color for Everyone #kopiyangbaik',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10,
                    color: Color(0xFF4A5550),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'S&K Berlaku',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 8.5,
                    color: Color(0xFF85938D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignatureCoffeePromoBanner extends StatelessWidget {
  const _SignatureCoffeePromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF07452E),
            Color(0xFF0D6B4C),
            Color(0xFF16835F),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(22, 80, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.softMintMist,
              borderRadius: AppSpacing.borderRadiusPill,
            ),
            child: Text(
              'SPECIAL PROMO #KOPIYANGBAIK',
              style: AppTextStyles.caption.copyWith(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: AppColors.neutralDark,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Diskon 30% Signature\nAren & Oat Series',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Gula aren organik murni & susu gandum ramah lingkungan.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFFD4F3E8),
            ),
          ),
        ],
      ),
    );
  }
}

class _EcoTumblerMovementBanner extends StatelessWidget {
  const _EcoTumblerMovementBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A5844),
            Color(0xFF28E5A7),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(22, 80, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppSpacing.borderRadiusPill,
            ),
            child: Text(
              '🌱 SUSTAINABILITY ACTION',
              style: AppTextStyles.caption.copyWith(
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
                color: AppColors.neutralDark,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Bawa Tumbler Sendiri\nHemat Rp 5.000 Setiap Order',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF011E13),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Bersama kurangi penggunaan sampah plastik sekali pakai.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF043825),
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter untuk mereplikasi showcase pastel tumbler di banner Fore
class _TumblerGridStudioPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Grid 3 kolom tumbler di sisi kanan (x: w * 0.50 s/d w)
    final bottles = [
      // Baris Atas
      {'x': w * 0.56, 'y': h * 0.36, 'color': const Color(0xFFE5E2FA), 'boot': const Color(0xFF8B82B5)},
      {'x': w * 0.74, 'y': h * 0.38, 'color': const Color(0xFFDEEBC4), 'boot': const Color(0xFFADC288)},
      {'x': w * 0.92, 'y': h * 0.36, 'color': const Color(0xFF165448), 'boot': const Color(0xFF38B2A1)},
      // Baris Bawah
      {'x': w * 0.56, 'y': h * 0.68, 'color': const Color(0xFFF7D1D5), 'boot': const Color(0xFFE29199)},
      {'x': w * 0.74, 'y': h * 0.70, 'color': const Color(0xFFE27546), 'boot': const Color(0xFFB54D22)},
      {'x': w * 0.92, 'y': h * 0.68, 'color': const Color(0xFF7A4A35), 'boot': const Color(0xFF4C2A1C)},
    ];

    for (final b in bottles) {
      final cx = b['x'] as double;
      final cy = b['y'] as double;
      final color = b['color'] as Color;
      final bootColor = b['boot'] as Color;

      // Botol silinder
      final bottleRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: 34, height: 74),
        const Radius.circular(14),
      );
      canvas.drawRRect(bottleRect, Paint()..color = color);

      // Tutup botol
      final capRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy - 38), width: 22, height: 14),
        const Radius.circular(5),
      );
      canvas.drawRRect(capRect, Paint()..color = color);

      // Silicone boot di bagian bawah botol
      final bootRect = RRect.fromRectAndCorners(
        Rect.fromCenter(center: Offset(cx, cy + 22), width: 36, height: 32),
        bottomLeft: const Radius.circular(14),
        bottomRight: const Radius.circular(14),
      );
      canvas.drawRRect(bootRect, Paint()..color = bootColor);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═════════════════════════════════════════════════════════════════════════════
// 2. FLOATING WELCOME CARD ("Welcome to Kopi B!" + "Login Sekarang")
// ═════════════════════════════════════════════════════════════════════════════
class _FloatingWelcomeCard extends StatelessWidget {
  const _FloatingWelcomeCard({
    required this.appState,
    required this.onLoginTap,
  });

  final KopiAppState appState;
  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Baris Atas: Welcome text + Tombol Login Sekarang
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Kopi B!',
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.neutralDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '#kopiyangbaik',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onLoginTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Login Sekarang',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Garis Pemisah Putus-Putus (Dashed Line)
          const _DashedHorizontalDivider(),

          // Baris Bawah: Subteks ramah
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFCFDFD),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            child: Text(
              'Berbagai rasa siap menemani harimu',
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
                color: const Color(0xFF55605B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedHorizontalDivider extends StatelessWidget {
  const _DashedHorizontalDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashSpace = 3.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 1.0,
              margin: const EdgeInsets.symmetric(horizontal: dashSpace / 2),
              color: const Color(0xFFE2E7E4),
            );
          }),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// 3. CARDS: "Pick Up" & "Delivery"
// ═════════════════════════════════════════════════════════════════════════════
class _OrderModeCard extends StatelessWidget {
  const _OrderModeCard({
    required this.title,
    required this.subtitle,
    required this.titleColor,
    required this.borderColor,
    required this.backgroundColor,
    required this.illustration,
    required this.onTap,
    this.tagLabel,
  });

  final String title;
  final String subtitle;
  final Color titleColor;
  final Color borderColor;
  final Color backgroundColor;
  final Widget illustration;
  final VoidCallback onTap;
  final String? tagLabel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 112,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.16),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    if (tagLabel != null) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: titleColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tagLabel!,
                          style: const TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                SizedBox(
                  width: 90,
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10.5,
                      color: Color(0xFF55605B),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),

            // Ilustrasi di Sudut Kanan Bawah
            Positioned(
              right: -4,
              bottom: -4,
              child: illustration,
            ),
          ],
        ),
      ),
    );
  }
}

class _BaristaIllustration extends StatelessWidget {
  const _BaristaIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 58,
      child: CustomPaint(
        painter: _BaristaPainter(),
      ),
    );
  }
}

class _BaristaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Lingkaran lembut latar
    canvas.drawCircle(
      Offset(w * 0.55, h * 0.55),
      22,
      Paint()..color = const Color(0xFFDCF2EA),
    );

    // Tubuh Barista apron hijau
    final apronPath = Path()
      ..moveTo(w * 0.35, h * 0.52)
      ..lineTo(w * 0.75, h * 0.52)
      ..lineTo(w * 0.82, h * 0.95)
      ..lineTo(w * 0.28, h * 0.95)
      ..close();
    canvas.drawPath(apronPath, Paint()..color = const Color(0xFF0D6B4C));

    // Kepala
    canvas.drawCircle(
      Offset(w * 0.55, h * 0.32),
      11,
      Paint()..color = const Color(0xFFF3C7A8),
    );

    // Rambut & Kacamata
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.55, h * 0.30), radius: 11),
      3.14,
      3.14,
      true,
      Paint()..color = const Color(0xFF32231A),
    );

    // Tas Kertas Kopi B di tangan
    final bagRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.58, 16, 20),
      const Radius.circular(3),
    );
    canvas.drawRRect(bagRect, Paint()..color = const Color(0xFFDCC19C));
    canvas.drawCircle(
      Offset(w * 0.18 + 8, h * 0.58 + 10),
      4,
      Paint()..color = const Color(0xFF0D6B4C),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CourierIllustration extends StatelessWidget {
  const _CourierIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: CustomPaint(
        painter: _CourierPainter(),
      ),
    );
  }
}

class _CourierPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Lingkaran lembut latar
    canvas.drawCircle(
      Offset(w * 0.50, h * 0.55),
      22,
      Paint()..color = const Color(0xFFFBEADB),
    );

    // Scooter badan merah/oranye
    final bodyPath = Path()
      ..moveTo(w * 0.20, h * 0.75)
      ..lineTo(w * 0.70, h * 0.75)
      ..lineTo(w * 0.60, h * 0.58)
      ..lineTo(w * 0.35, h * 0.58)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFFC04E35));

    // Roda
    canvas.drawCircle(
      Offset(w * 0.28, h * 0.82),
      7,
      Paint()..color = const Color(0xFF333333),
    );
    canvas.drawCircle(
      Offset(w * 0.68, h * 0.82),
      7,
      Paint()..color = const Color(0xFF333333),
    );

    // Rider Helm Hijau Kopi B
    canvas.drawCircle(
      Offset(w * 0.46, h * 0.38),
      9,
      Paint()..color = const Color(0xFF0D6B4C),
    );

    // Delivery Box di belakang motor
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.45, 14, 15),
      const Radius.circular(2),
    );
    canvas.drawRRect(boxRect, Paint()..color = const Color(0xFF05452E));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═════════════════════════════════════════════════════════════════════════════
// 4. SECTION: "Spesial Untukmu di Kopi B" (2x2 Grid Cards)
// ═════════════════════════════════════════════════════════════════════════════
class _SpecialFeatureCard extends StatelessWidget {
  const _SpecialFeatureCard({
    required this.title,
    required this.subtitle,
    required this.iconPainter,
    required this.onTap,
    this.badgeText,
  });

  final String title;
  final String subtitle;
  final CustomPainter iconPainter;
  final VoidCallback onTap;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 148,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE8EDE9),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ilustrasi Doodle Tengah
                  SizedBox(
                    width: 58,
                    height: 52,
                    child: CustomPaint(painter: iconPainter),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E2421),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10.5,
                      color: Color(0xFF6E7873),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),

            // Badge Merah "Baru" di Pojok Kanan Atas
            if (badgeText != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFC04E35),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum _DoodleType { cupPlan, tumbler, groupOrder, stampReward }

class _FeatureDoodlePainter extends CustomPainter {
  const _FeatureDoodlePainter({required this.type});

  final _DoodleType type;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (type) {
      case _DoodleType.cupPlan:
        // Cangkir Kopi B dengan 3 Teman Mengintip
        final cupPath = Path()
          ..moveTo(w * 0.20, h * 0.45)
          ..lineTo(w * 0.80, h * 0.45)
          ..lineTo(w * 0.70, h * 0.90)
          ..quadraticBezierTo(w * 0.50, h * 0.96, w * 0.30, h * 0.90)
          ..close();
        canvas.drawPath(cupPath, Paint()..color = const Color(0xFFD4EAE2));

        // 3 Karakter lucu di cangkir
        final charPaint = Paint()..color = const Color(0xFF8B4D3B);
        canvas.drawCircle(Offset(w * 0.36, h * 0.38), 7, charPaint);
        canvas.drawCircle(Offset(w * 0.50, h * 0.34), 8, charPaint);
        canvas.drawCircle(Offset(w * 0.64, h * 0.38), 7, charPaint);

        // Logo Kopi B di cangkir
        canvas.drawCircle(
          Offset(w * 0.50, h * 0.68),
          6,
          Paint()..color = const Color(0xFF0D6B4C),
        );
        break;

      case _DoodleType.tumbler:
        // Botol Tumbler Pastel + Hewan Lucu di sampingnya
        final tumblerRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.22, h * 0.20, 16, 38),
          const Radius.circular(7),
        );
        canvas.drawRRect(tumblerRect, Paint()..color = const Color(0xFF5BA4B5));

        final tumbler2 = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.42, h * 0.30, 15, 30),
          const Radius.circular(6),
        );
        canvas.drawRRect(tumbler2, Paint()..color = const Color(0xFFE5B57A));

        // Maskot kecil di sebelah tumbler
        canvas.drawCircle(
          Offset(w * 0.70, h * 0.52),
          9,
          Paint()..color = const Color(0xFFC79268),
        );
        break;

      case _DoodleType.groupOrder:
        // Karakter membawa banyak cup kopi
        canvas.drawCircle(
          Offset(w * 0.42, h * 0.38),
          9,
          Paint()..color = const Color(0xFF8B4D3B),
        );
        for (int i = 0; i < 4; i++) {
          final cupRect = RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.28 + (i * 9), h * 0.52, 10, 14),
            const Radius.circular(2),
          );
          canvas.drawRRect(
            cupRect,
            Paint()..color = const Color(0xFF0D6B4C),
          );
        }
        break;

      case _DoodleType.stampReward:
        // Karakter bersorak bersama kucing/anjing
        canvas.drawCircle(
          Offset(w * 0.38, h * 0.36),
          9,
          Paint()..color = const Color(0xFF8B4D3B),
        );
        canvas.drawCircle(
          Offset(w * 0.65, h * 0.44),
          8,
          Paint()..color = const Color(0xFFE5A638),
        );
        canvas.drawCircle(
          Offset(w * 0.52, h * 0.72),
          10,
          Paint()..color = const Color(0xFF28E5A7),
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Floating Circular Sticker "NEW! #kopiyangbaik"
class _FloatingArtisanalBadge extends StatelessWidget {
  const _FloatingArtisanalBadge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF14533C),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'NEW!',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF28E5A7),
              ),
            ),
            Text(
              'KOPI B',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// 5. COMPACT BEST SELLER CARD
// ═════════════════════════════════════════════════════════════════════════════
class _CompactBestSellerCard extends StatelessWidget {
  const _CompactBestSellerCard({
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
        width: 156,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceMint,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.sageSlate.withValues(alpha: 0.35),
          ),
          boxShadow: AppSpacing.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: KopiProductVisual(product: product, size: 76),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.heading2.copyWith(fontSize: 13.5),
            ),
            const SizedBox(height: 2),
            Text(
              '${product.calories} kkal • ★ ${product.rating}',
              style: AppTextStyles.caption.copyWith(fontSize: 10.5),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatRupiah(product.price),
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: 13.5,
                    color: AppColors.primary,
                  ),
                ),
                KopiCircleActionButton(
                  icon: Icons.add_rounded,
                  size: 30,
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
