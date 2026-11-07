import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/kopi_button.dart';
import '../models/kopi_models.dart';
import '../state/kopi_app_state.dart';

/// Ilustrasi visual produk kopi/bakery artisanal dengan aksen daun botanical
class KopiProductVisual extends StatelessWidget {
  const KopiProductVisual({
    super.key,
    required this.product,
    this.size = 76,
  });

  final CoffeeProduct product;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isBakery = product.category == MenuCategory.bakery;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.background,
            product.cupColor.withValues(alpha: 0.22),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(
          color: AppColors.sageSlate.withValues(alpha: 0.35),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran aksen lembut di belakang cup
          Container(
            width: size * 0.68,
            height: size * 0.68,
            decoration: BoxDecoration(
              color: product.cupColor.withValues(alpha: 0.20),
              shape: BoxShape.circle,
            ),
          ),
          // Ilustrasi Cup Kopi B atau Bakery
          if (isBakery)
            Icon(
              Icons.bakery_dining_rounded,
              size: size * 0.48,
              color: product.cupColor,
            )
          else
            CustomPaint(
              size: Size(size * 0.54, size * 0.64),
              painter: _ArtisanalCupPainter(
                liquidColor: product.cupColor,
                sleeveColor: AppColors.primary,
                isIced: product.defaultIced,
              ),
            ),
          // Ikon daun kecil penanda artisanal botanical
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppColors.softMintMist,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.eco_rounded,
                size: 11,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArtisanalCupPainter extends CustomPainter {
  const _ArtisanalCupPainter({
    required this.liquidColor,
    required this.sleeveColor,
    required this.isIced,
  });

  final Color liquidColor;
  final Color sleeveColor;
  final bool isIced;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sedotan hijau jika minuman dingin
    if (isIced) {
      final strawPaint = Paint()
        ..color = AppColors.primary
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(w * 0.58, h * 0.02),
        Offset(w * 0.50, h * 0.30),
        strawPaint,
      );
    }

    // Badan Cup (Trapesium membulat)
    final cupPath = Path()
      ..moveTo(w * 0.14, h * 0.24)
      ..lineTo(w * 0.86, h * 0.24)
      ..lineTo(w * 0.76, h * 0.94)
      ..quadraticBezierTo(w * 0.50, h * 0.98, w * 0.24, h * 0.94)
      ..close();

    final cupPaint = Paint()..color = liquidColor;
    canvas.drawPath(cupPath, cupPaint);

    // Lapisan Foam / Cream di bagian atas cup
    final foamPath = Path()
      ..moveTo(w * 0.14, h * 0.24)
      ..lineTo(w * 0.86, h * 0.24)
      ..lineTo(w * 0.83, h * 0.42)
      ..quadraticBezierTo(w * 0.50, h * 0.46, w * 0.17, h * 0.42)
      ..close();
    canvas.drawPath(
      foamPath,
      Paint()..color = const Color(0xFFFFFBF5).withValues(alpha: 0.85),
    );

    // Sleeve Hijau "Kopi B" di bagian tengah cup
    final sleevePath = Path()
      ..moveTo(w * 0.18, h * 0.50)
      ..lineTo(w * 0.82, h * 0.50)
      ..lineTo(w * 0.79, h * 0.72)
      ..lineTo(w * 0.21, h * 0.72)
      ..close();
    canvas.drawPath(sleevePath, Paint()..color = sleeveColor);

    // Titik logo putih di tengah sleeve
    canvas.drawCircle(
      Offset(w * 0.50, h * 0.61),
      w * 0.09,
      Paint()..color = Colors.white,
    );

    // Tutup Dome / Lid
    final lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.17, w * 0.80, h * 0.08),
      const Radius.circular(4),
    );
    canvas.drawRRect(
      lidRect,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bottom Sheet Kustomisasi Minuman Kopi B (Es/Panas, Level Gula, Susu, Size)
void showDrinkCustomizationSheet({
  required BuildContext context,
  required CoffeeProduct product,
  required KopiAppState appState,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _DrinkCustomizationSheet(
      product: product,
      appState: appState,
    ),
  );
}

class _DrinkCustomizationSheet extends StatefulWidget {
  const _DrinkCustomizationSheet({
    required this.product,
    required this.appState,
  });

  final CoffeeProduct product;
  final KopiAppState appState;

  @override
  State<_DrinkCustomizationSheet> createState() =>
      _DrinkCustomizationSheetState();
}

class _DrinkCustomizationSheetState extends State<_DrinkCustomizationSheet> {
  late bool _isIced;
  String _sugarLevel = 'Less Sugar';
  late String _milkOption;
  String _cupSize = 'Regular';
  bool _extraShot = false;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _isIced = widget.product.defaultIced;
    _milkOption =
        widget.product.isOatDefault ? 'Oat Milk' : 'Fresh Milk';
  }

  CartItem get _previewItem => CartItem(
        product: widget.product,
        quantity: _quantity,
        isIced: _isIced,
        sugarLevel: _sugarLevel,
        milkOption: _milkOption,
        cupSize: _cupSize,
        extraShot: _extraShot,
      );

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.sageSlate.withValues(alpha: 0.5),
                    borderRadius: AppSpacing.borderRadiusPill,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Header info produk
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KopiProductVisual(product: p, size: 84),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (p.badgeText != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.softMintMist,
                              borderRadius: AppSpacing.borderRadiusPill,
                            ),
                            child: Text(
                              p.badgeText!,
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        Text(p.name, style: AppTextStyles.heading1),
                        const SizedBox(height: 4),
                        Text(p.description, style: AppTextStyles.body),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department_outlined,
                              size: 15,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${p.calories} kkal',
                              style: AppTextStyles.caption,
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${p.rating}',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.neutralDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (p.supportsCustomization) ...[
                const SizedBox(height: AppSpacing.xl),
                const Divider(),
                const SizedBox(height: AppSpacing.md),

                // 1. Temperatur
                Text('Temperatur', style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _OptionChip(
                        label: 'Iced (Dingin) ❄️',
                        selected: _isIced,
                        onTap: () => setState(() => _isIced = true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _OptionChip(
                        label: 'Hot (Panas) ☕',
                        selected: !_isIced,
                        onTap: () => setState(() => _isIced = false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // 2. Ukuran Cup
                Text('Ukuran Cup', style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _OptionChip(
                        label: 'Regular (Standard)',
                        selected: _cupSize == 'Regular',
                        onTap: () => setState(() => _cupSize = 'Regular'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _OptionChip(
                        label: 'Large (+Rp 5.000)',
                        selected: _cupSize == 'Large',
                        onTap: () => setState(() => _cupSize = 'Large'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // 3. Level Gula
                Text('Level Gula (#kopiyangbaik)', style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: ['Normal Sugar', 'Less Sugar', 'No Sugar'].map((s) {
                    return _OptionChip(
                      label: s,
                      selected: _sugarLevel == s,
                      onTap: () => setState(() => _sugarLevel = s),
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppSpacing.lg),

                // 4. Pilihan Susu & Extra Shot
                Text('Pilihan Susu & Espresso', style: AppTextStyles.heading2),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _OptionChip(
                        label: 'Fresh Milk',
                        selected: _milkOption == 'Fresh Milk',
                        onTap: () => setState(() => _milkOption = 'Fresh Milk'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _OptionChip(
                        label: p.isOatDefault
                            ? 'Oat Milk 🌾 (Included)'
                            : 'Oat Milk 🌾 (+Rp 6rb)',
                        selected: _milkOption == 'Oat Milk',
                        onTap: () => setState(() => _milkOption = 'Oat Milk'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  tileColor: AppColors.surfaceMint,
                  activeTrackColor: AppColors.primary,
                  title: Text(
                    'Tambah Extra Espresso Shot (+Rp 6.000)',
                    style: AppTextStyles.bodyMedium,
                  ),
                  subtitle: Text(
                    '100% House Blend Arabica Gayo',
                    style: AppTextStyles.caption,
                  ),
                  value: _extraShot,
                  onChanged: (v) => setState(() => _extraShot = v),
                ),
              ],

              const SizedBox(height: AppSpacing.xl),

              // Bar Bawah: Jumlah & Tombol Tambah ke Keranjang
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMint,
                      borderRadius: AppSpacing.borderRadiusMd,
                      border: Border.all(color: AppColors.sageSlate),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          icon: const Icon(Icons.remove_rounded, size: 18),
                          color: AppColors.primaryDark,
                        ),
                        Text(
                          '$_quantity',
                          style: AppTextStyles.heading2,
                        ),
                        IconButton(
                          onPressed: () => setState(() => _quantity++),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: KopiButton(
                      label:
                          'Tambah • ${formatRupiah(_previewItem.totalPrice)}',
                      icon: Icons.shopping_bag_outlined,
                      height: 50,
                      onPressed: () {
                        widget.appState.addToCart(_previewItem);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            content: Text(
                              '${p.name} ditambahkan ke keranjang',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceMint,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.sageSlate,
            width: 1.2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.background : AppColors.primaryDark,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom Sheet Pemilihan Outlet Terdekat
void showOutletSelectorSheet({
  required BuildContext context,
  required KopiAppState appState,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Outlet Kopi B Terdekat', style: AppTextStyles.heading1),
            const SizedBox(height: 4),
            Text(
              'Kopi disiapkan langsung oleh barista saat kamu memesan',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.lg),
            ...appState.outlets.map((outlet) {
              final isSelected = outlet.id == appState.selectedOutlet.id;
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.surfaceMint
                      : AppColors.background,
                  borderRadius: AppSpacing.borderRadiusCard,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.sageSlate,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    appState.selectOutlet(outlet);
                    Navigator.pop(ctx);
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceMint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.storefront_rounded,
                      color: isSelected
                          ? AppColors.background
                          : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(outlet.name, style: AppTextStyles.heading2),
                  subtitle: Text(
                    '${outlet.address}\n${outlet.distanceKm} km • Siap dalam ~${outlet.prepMinutes} menit',
                    style: AppTextStyles.caption,
                  ),
                  isThreeLine: true,
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                ),
              );
            }),
          ],
        ),
      );
    },
  );
}

/// Bottom Sheet Ringkasan Keranjang & Checkout Cepat
void showCartCheckoutSheet({
  required BuildContext context,
  required KopiAppState appState,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          if (appState.cart.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_cafe_outlined,
                    size: 48,
                    color: AppColors.tertiary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Keranjang Masih Kosong', style: AppTextStyles.heading1),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Yuk pilih kopi artisanal favoritmu dari menu Kopi B!',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            );
          }

          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ringkasan Pesanan (${appState.orderMode.title})',
                          style: AppTextStyles.heading1,
                        ),
                        TextButton(
                          onPressed: () {
                            appState.clearCart();
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            'Kosongkan',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Outlet: ${appState.selectedOutlet.name} (~${appState.selectedOutlet.prepMinutes} mnt)',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Daftar Item Keranjang
                    ...List.generate(appState.cart.length, (i) {
                      final item = appState.cart[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: AppSpacing.cardPaddingCompact,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMint,
                          borderRadius: AppSpacing.borderRadiusCard,
                        ),
                        child: Row(
                          children: [
                            KopiProductVisual(product: item.product, size: 54),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: AppTextStyles.heading2.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    item.customizationSummary,
                                    style: AppTextStyles.caption,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatRupiah(item.totalPrice),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                KopiCircleActionButton(
                                  icon: item.quantity == 1
                                      ? Icons.delete_outline_rounded
                                      : Icons.remove_rounded,
                                  isDestructive: item.quantity == 1,
                                  size: 32,
                                  onTap: () =>
                                      appState.updateCartQuantity(i, -1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    '${item.quantity}',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                KopiCircleActionButton(
                                  icon: Icons.add_rounded,
                                  size: 32,
                                  onTap: () =>
                                      appState.updateCartQuantity(i, 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: AppSpacing.sm),

                    // Opsi Eco-Tumbler
                    SwitchListTile.adaptive(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      tileColor: AppColors.surfaceSoft,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.borderRadiusMd,
                        side: const BorderSide(color: AppColors.sageSlate),
                      ),
                      activeTrackColor: AppColors.primary,
                      title: Text(
                        'Bawa Tumbler Sendiri 🌱 (-Rp 5.000)',
                        style: AppTextStyles.bodyMedium,
                      ),
                      subtitle: Text(
                        'Gerakan ramah lingkungan #kopiyangbaik',
                        style: AppTextStyles.caption,
                      ),
                      value: appState.bringOwnTumbler,
                      onChanged: appState.toggleBringOwnTumbler,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Ringkasan Biaya
                    _PriceRow(
                      label: 'Subtotal',
                      value: formatRupiah(appState.cartSubtotal),
                    ),
                    if (appState.voucherDiscount > 0)
                      _PriceRow(
                        label: 'Promo (${appState.appliedVoucher!.code})',
                        value: '-${formatRupiah(appState.voucherDiscount)}',
                        isHighlight: true,
                      ),
                    if (appState.tumblerDiscount > 0)
                      _PriceRow(
                        label: 'Eco-Tumbler Reward',
                        value: '-${formatRupiah(appState.tumblerDiscount)}',
                        isHighlight: true,
                      ),
                    const Divider(height: 20),
                    _PriceRow(
                      label: 'Total Pembayaran (${appState.selectedPaymentMethod.split(' ').first})',
                      value: formatRupiah(appState.cartTotal),
                      isBold: true,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    KopiButton(
                      label:
                          'Bayar & Seduh Sekarang • ${formatRupiah(appState.cartTotal)}',
                      icon: Icons.check_circle_outline_rounded,
                      isFullWidth: true,
                      height: 50,
                      onPressed: () {
                        final order = appState.checkoutOrder();
                        Navigator.pop(ctx);
                        if (order != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                'Pesanan ${order.id} diterima! Barista sedang menyiapkan kopimu (+${order.earnedBeans} B-Beans).',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isHighlight;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final style = isBold ? AppTextStyles.heading2 : AppTextStyles.body;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            value,
            style: style.copyWith(
              color: isHighlight
                  ? AppColors.secondaryDark
                  : AppColors.neutralDark,
              fontWeight:
                  (isBold || isHighlight) ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
