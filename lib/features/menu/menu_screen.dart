import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/kopi_button.dart';
import '../../core/widgets/kopi_search_bar.dart';
import '../shared/models/kopi_models.dart';
import '../shared/state/kopi_app_state.dart';
import '../shared/widgets/product_visual_and_modals.dart';

/// Menu Screen Kopi B (#kopiyangbaik) sesuai DESIGN_SYSTEM.md Bagian 6 & 7
/// Katalog lengkap kopi, non-kopi, oat series, dan bakery dengan filter
/// diet/temperatur, kustomisasi minuman, dan keranjang apung.
class MenuScreen extends StatefulWidget {
  const MenuScreen({
    super.key,
    required this.appState,
  });

  final KopiAppState appState;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  MenuCategory? _selectedCategory;
  String _activeDietFilter = 'Semua';

  static const List<String> _dietFilters = [
    'Semua',
    'Plant-Based Oat 🌾',
    'Rendah Kalori (<150 kkal)',
    'Best Seller ⭐',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CoffeeProduct> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return widget.appState.products.where((p) {
      if (_selectedCategory != null && p.category != _selectedCategory) {
        return false;
      }
      if (_activeDietFilter == 'Plant-Based Oat 🌾' && !p.isOatDefault) {
        return false;
      }
      if (_activeDietFilter == 'Rendah Kalori (<150 kkal)' &&
          p.calories >= 150) {
        return false;
      }
      if (_activeDietFilter == 'Best Seller ⭐' && !p.isBestSeller) {
        return false;
      }
      if (query.isNotEmpty) {
        return p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Menu Kopi B', style: AppTextStyles.heading1),
            Text(
              '${widget.appState.orderMode.title} • ${widget.appState.selectedOutlet.name}',
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: KopiButton(
              label: widget.appState.orderMode.title,
              icon: widget.appState.orderMode.icon,
              variant: KopiButtonVariant.secondary,
              height: 36,
              isPill: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () => showOutletSelectorSheet(
                context: context,
                appState: widget.appState,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar sesuai UI Kit Board
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xs,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: KopiSearchBar(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              onClear: () {
                _searchController.clear();
                setState(() {});
              },
            ),
          ),

          // 2. Navigasi Kategori Kopi Interaktif
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: AppSpacing.screenHorizontal,
              children: [
                _CategoryPill(
                  label: 'Semua Menu',
                  icon: Icons.grid_view_rounded,
                  selected: _selectedCategory == null,
                  onTap: () => setState(() => _selectedCategory = null),
                ),
                const SizedBox(width: AppSpacing.sm),
                ...MenuCategory.values.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: _CategoryPill(
                      label: cat.label,
                      icon: cat.icon,
                      selected: _selectedCategory == cat,
                      onTap: () => setState(() => _selectedCategory = cat),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // 3. Filter Diet / Preferensi Cepat
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: AppSpacing.screenHorizontal,
              itemCount: _dietFilters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _dietFilters[index];
                final isSelected = _activeDietFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _activeDietFilter = filter),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.softMintMist
                          : AppColors.surfaceSoft,
                      borderRadius: AppSpacing.borderRadiusPill,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.sageSlate,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // 4. Daftar Katalog Produk
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppColors.tertiary,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Menu tidak ditemukan',
                          style: AppTextStyles.heading2,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      110,
                    ),
                    itemCount: products.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _MenuCatalogCard(
                        product: product,
                        appState: widget.appState,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceMint,
          borderRadius: AppSpacing.borderRadiusPill,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? AppColors.background : AppColors.primaryDark,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? AppColors.background : AppColors.primaryDark,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCatalogCard extends StatelessWidget {
  const _MenuCatalogCard({
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
            KopiProductVisual(product: product, size: 84),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (product.badgeText != null)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
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
                      Text(
                        '${product.calories} kkal',
                        style: AppTextStyles.caption.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(product.name, style: AppTextStyles.heading2),
                  const SizedBox(height: 2),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            formatRupiah(product.price),
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.primary,
                              fontSize: 16,
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
                      KopiButton(
                        label: 'Pilih',
                        icon: Icons.add_rounded,
                        height: 34,
                        isPill: true,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        onPressed: () => showDrinkCustomizationSheet(
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
          ],
        ),
      ),
    );
  }
}

