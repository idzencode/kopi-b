import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/kopi_button.dart';
import '../auth/auth_onboarding_screens.dart';
import '../design_system/design_system_showcase_screen.dart';
import '../shared/state/kopi_app_state.dart';

/// Akun Screen Kopi B (#kopiyangbaik) sesuai DESIGN_SYSTEM.md Bagian 6 & 7
/// Menampilkan profil pengguna, Eco-Impact Tracker, metode pembayaran,
/// serta akses kembali ke alur Masuk / Onboarding 3 layar.
class AccountScreen extends StatelessWidget {
  const AccountScreen({
    super.key,
    required this.appState,
  });

  final KopiAppState appState;

  static const List<String> _paymentMethods = [
    'GoPay (Rp 185.000)',
    'OVO Cash (Rp 120.000)',
    'ShopeePay (Rp 94.500)',
    'QRIS Instan',
    'Kartu Debit / Kredit Visa',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Akun Saya', style: AppTextStyles.heading1),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          110,
        ),
        children: [
          // 1. Kartu Profil Pengguna
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.surfaceMint,
              borderRadius: AppSpacing.borderRadiusCardLg,
              border: AppSpacing.subtleBorder,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    appState.userName.substring(0, 1),
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appState.userName, style: AppTextStyles.heading1),
                      const SizedBox(height: 2),
                      Text(
                        '${appState.memberTier} • ${appState.bBeansPoints} B-Beans',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // 2. Eco-Impact Tracker (#kopiyangbaik Sustainability)
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.softMintMist.withValues(alpha: 0.45),
              borderRadius: AppSpacing.borderRadiusCard,
              border: Border.all(color: AppColors.secondaryDark),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.eco_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${appState.savedPlasticCups} Cup Plastik Dihemat 🌱',
                        style: AppTextStyles.heading2,
                      ),
                      Text(
                        'Terima kasih telah membawa tumbler di gerakan #kopiyangbaik!',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 3. Metode Pembayaran Utama
          Text('Metode Pembayaran Utama', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.sm),
          ..._paymentMethods.map((method) {
            final isSelected = appState.selectedPaymentMethod == method;
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.surfaceMint
                    : AppColors.surfaceSoft,
                borderRadius: AppSpacing.borderRadiusMd,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.sageSlate,
                ),
              ),
              child: ListTile(
                dense: true,
                onTap: () => appState.selectPaymentMethod(method),
                leading: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.primary,
                ),
                title: Text(method, style: AppTextStyles.bodyMedium),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                      )
                    : null,
              ),
            );
          }),

          const SizedBox(height: AppSpacing.lg),

          // 4. Tombol Uji Coba Alur Pendaftaran / Masuk (3 Layar) & UI Kit Board
          KopiButton(
            label: 'Buka Alur Masuk / Pendaftaran (3 Screen)',
            icon: Icons.login_rounded,
            variant: KopiButtonVariant.outlined,
            isFullWidth: true,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (routeCtx) => WelcomeOnboardingScreen(
                    onSkipToHome: () => Navigator.of(routeCtx).pop(),
                    onLoginSuccess: (phone) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          content: Text('Berhasil masuk dengan nomor $phone'),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          KopiButton(
            label: 'Lihat Design System UI Kit Board',
            icon: Icons.palette_outlined,
            variant: KopiButtonVariant.secondary,
            isFullWidth: true,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const DesignSystemShowcaseScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

