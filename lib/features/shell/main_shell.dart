import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/kopi_bottom_nav_bar.dart';
import '../account/account_screen.dart';
import '../home/home_screen.dart';
import '../menu/menu_screen.dart';
import '../order/order_screen.dart';
import '../reward/reward_screen.dart';
import '../shared/models/kopi_models.dart';
import '../shared/state/kopi_app_state.dart';
import '../shared/widgets/product_visual_and_modals.dart';

/// Main Shell 5-Tab Persisten (Home, Menu, Order, Reward, Akun)
/// Dilengkapi Floating Cart Bar yang melayang di atas Bottom Navigation.
class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.appState,
  });

  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final screens = <Widget>[
          HomeScreen(appState: appState),
          MenuScreen(appState: appState),
          OrderScreen(appState: appState),
          RewardScreen(appState: appState),
          AccountScreen(appState: appState),
        ];

        final showFloatingCart = appState.cart.isNotEmpty &&
            (appState.currentTabIndex == 0 || appState.currentTabIndex == 1);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              IndexedStack(
                index: appState.currentTabIndex,
                children: screens,
              ),

              // Floating Cart Bar melayang di atas Bottom Navigation Bar
              if (showFloatingCart)
                Positioned(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: 12,
                  child: _FloatingCartBar(appState: appState),
                ),
            ],
          ),
          bottomNavigationBar: KopiBottomNavBar(
            currentIndex: appState.currentTabIndex,
            activeOrderCount: appState.activeOrderCount,
            onTap: appState.setTabIndex,
          ),
        );
      },
    );
  }
}

class _FloatingCartBar extends StatelessWidget {
  const _FloatingCartBar({required this.appState});

  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: AppSpacing.borderRadiusPill,
      elevation: 6,
      shadowColor: AppColors.neutralDark.withValues(alpha: 0.25),
      child: InkWell(
        borderRadius: AppSpacing.borderRadiusPill,
        onTap: () => showCartCheckoutSheet(
          context: context,
          appState: appState,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 12,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
                child: Text(
                  '${appState.totalCartItems} Item',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.neutralDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${appState.orderMode.title} • ${appState.selectedOutlet.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.surfaceMint,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      formatRupiah(appState.cartTotal),
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.background,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Checkout',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.softMintMist,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.softMintMist,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

