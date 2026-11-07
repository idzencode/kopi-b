import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/kopi_button.dart';
import '../../core/widgets/kopi_progress_bar.dart';
import '../shared/models/kopi_models.dart';
import '../shared/state/kopi_app_state.dart';
import '../shared/widgets/product_visual_and_modals.dart';

/// Order Screen Kopi B (#kopiyangbaik) sesuai DESIGN_SYSTEM.md Bagian 6 & 7
/// Menampilkan pelacakan proses barista (Brewing / Ready for Pick-up),
/// kode ambil pesanan, e-receipt, dan riwayat pesanan.
class OrderScreen extends StatelessWidget {
  const OrderScreen({
    super.key,
    required this.appState,
  });

  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    final activeOrders =
        appState.orders.where((o) => !o.isCompleted).toList();
    final pastOrders =
        appState.orders.where((o) => o.isCompleted).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Pesanan Saya', style: AppTextStyles.heading1),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          110,
        ),
        children: [
          if (activeOrders.isNotEmpty) ...[
            Text(
              'Sedang Disiapkan Barista (${activeOrders.length})',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSpacing.sm),
            ...activeOrders.map(
              (order) => _ActiveOrderCard(
                order: order,
                appState: appState,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          Text(
            'Riwayat Pesanan',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (pastOrders.isEmpty)
            Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                color: AppColors.surfaceSoft,
                borderRadius: AppSpacing.borderRadiusCard,
              ),
              child: Text(
                'Belum ada riwayat pesanan selesai.',
                style: AppTextStyles.body,
              ),
            )
          else
            ...pastOrders.map(
              (order) => _PastOrderCard(
                order: order,
                appState: appState,
              ),
            ),
        ],
      ),
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({
    required this.order,
    required this.appState,
  });

  final CoffeeOrder order;
  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceMint,
        borderRadius: AppSpacing.borderRadiusCardLg,
        border: Border.all(color: AppColors.primary, width: 1.3),
        boxShadow: AppSpacing.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header kode pickup & status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
                child: Text(
                  '${order.mode.title} • Kode ${order.pickupCode}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.background,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(order.createdAt, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Status Barista & Progress Bar
          Text(order.stage.title, style: AppTextStyles.heading1),
          const SizedBox(height: 2),
          Text(order.stage.subtitle, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.md),
          KopiProgressBar(
            progress: order.stage.progress,
            height: 8,
            activeColor: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.md),

          // Outlet
          Row(
            children: [
              const Icon(
                Icons.storefront_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.outlet.name,
                  style: AppTextStyles.bodyMedium,
                ),
              ),
            ],
          ),
          const Divider(height: 22),

          // Item ringkas
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  KopiProductVisual(product: item.product, size: 42),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.quantity}x ${item.product.name}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          item.customizationSummary,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatRupiah(item.totalPrice),
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: KopiButton(
                  label: 'E-Receipt',
                  icon: Icons.receipt_outlined,
                  variant: KopiButtonVariant.outlined,
                  height: 40,
                  onPressed: () => _showEReceiptModal(context, order),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: KopiButton(
                  label: order.stage == OrderStage.ready
                      ? 'Selesaikan Pesanan'
                      : 'Simulasi Tahap Berikutnya',
                  variant: KopiButtonVariant.primary,
                  height: 40,
                  onPressed: () => appState.advanceOrderStage(order.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showEReceiptModal(BuildContext context, CoffeeOrder order) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('E-Receipt #kopiyangbaik', style: AppTextStyles.heading1),
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
                      'Kode Ambil: ${order.pickupCode}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.neutralDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${order.id} • ${order.createdAt} • ${order.outlet.name}',
                style: AppTextStyles.caption,
              ),
              const Divider(height: 24),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.product.name} (${item.customizationSummary})',
                          style: AppTextStyles.body,
                        ),
                      ),
                      Text(
                        formatRupiah(item.totalPrice),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal', style: AppTextStyles.body),
                  Text(formatRupiah(order.subtotal), style: AppTextStyles.body),
                ],
              ),
              if (order.discount > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Diskon Promo', style: AppTextStyles.body),
                    Text(
                      '-${formatRupiah(order.discount)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondaryDark,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total (${order.paymentMethod})',
                    style: AppTextStyles.heading2,
                  ),
                  Text(
                    formatRupiah(order.total),
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              KopiButton(
                label: 'Tutup Struk Digital',
                isFullWidth: true,
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _PastOrderCard extends StatelessWidget {
  const _PastOrderCard({
    required this.order,
    required this.appState,
  });

  final CoffeeOrder order;
  final KopiAppState appState;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: AppSpacing.borderRadiusCard,
        border: AppSpacing.subtleBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.outlet.name, style: AppTextStyles.heading2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.softMintMist,
                  borderRadius: AppSpacing.borderRadiusPill,
                ),
                child: Text(
                  'Selesai • +${order.earnedBeans} Beans',
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
            '${order.id} • ${order.createdAt}',
            style: AppTextStyles.caption,
          ),
          const Divider(height: 20),
          ...order.items.map(
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${i.quantity}x ${i.product.name} (${i.customizationSummary})',
                style: AppTextStyles.body,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${formatRupiah(order.total)}',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary,
                ),
              ),
              KopiButton(
                label: 'Pesan Lagi',
                icon: Icons.replay_rounded,
                variant: KopiButtonVariant.secondary,
                height: 36,
                onPressed: () => appState.reorderFromHistory(order),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

