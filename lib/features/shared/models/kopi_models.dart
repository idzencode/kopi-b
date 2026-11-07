import 'package:flutter/material.dart';

/// Kategori Menu Kopi B
enum MenuCategory {
  signature('Signature Kopi B', Icons.auto_awesome_rounded),
  espresso('Espresso Based', Icons.coffee_rounded),
  oatSeries('Oat Series 🌾', Icons.grass_rounded),
  nonCoffee('Non-Coffee', Icons.emoji_food_beverage_rounded),
  bakery('Artisanal Bakery', Icons.bakery_dining_rounded);

  const MenuCategory(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Metode Pemesanan (Pick Up di Outlet vs Delivery)
enum OrderMode {
  pickUp('Pick Up', 'Ambil langsung tanpa antre', Icons.storefront_rounded),
  delivery('Delivery', 'Diantar hangat/dingin ke lokasimu', Icons.delivery_dining_rounded);

  const OrderMode(this.title, this.subtitle, this.icon);
  final String title;
  final String subtitle;
  final IconData icon;
}

/// Tahap Pelacakan Pesanan Aktif
enum OrderStage {
  received('Pesanan Diterima', 'Outlet telah menerima pesananmu', 0.33),
  brewing('Barista Sedang Menyeduh', 'Biji kopi pilihan sedang diekstraksi', 0.68),
  ready('Siap Diambil / Diantar', 'Silakan ambil di Pick-Up Bar Kopi B', 1.0);

  const OrderStage(this.title, this.subtitle, this.progress);
  final String title;
  final String subtitle;
  final double progress;
}

/// Model Item Katalog Menu Kopi B
class CoffeeProduct {
  const CoffeeProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.calories,
    required this.rating,
    required this.accentColor,
    required this.cupColor,
    this.originalPrice,
    this.badgeText,
    this.isBestSeller = false,
    this.isOatDefault = false,
    this.supportsCustomization = true,
    this.defaultIced = true,
  });

  final String id;
  final String name;
  final String description;
  final int price;
  final int? originalPrice;
  final MenuCategory category;
  final int calories;
  final double rating;
  final Color accentColor;
  final Color cupColor;
  final String? badgeText;
  final bool isBestSeller;
  final bool isOatDefault;
  final bool supportsCustomization;
  final bool defaultIced;
}

/// Kustomisasi Minuman & Item Keranjang
class CartItem {
  CartItem({
    required this.product,
    this.quantity = 1,
    this.isIced = true,
    this.sugarLevel = 'Normal Sugar',
    this.milkOption = 'Fresh Milk',
    this.cupSize = 'Regular',
    this.extraShot = false,
    this.notes = '',
  });

  final CoffeeProduct product;
  int quantity;
  final bool isIced;
  final String sugarLevel;
  final String milkOption;
  final String cupSize;
  final bool extraShot;
  final String notes;

  int get unitPrice {
    if (!product.supportsCustomization) return product.price;
    int extra = 0;
    if (milkOption == 'Oat Milk' && !product.isOatDefault) extra += 6000;
    if (cupSize == 'Large') extra += 5000;
    if (extraShot) extra += 6000;
    return product.price + extra;
  }

  int get totalPrice => unitPrice * quantity;

  String get customizationSummary {
    if (!product.supportsCustomization) return 'Disajikan hangat (Fresh Baked)';
    final parts = <String>[
      isIced ? 'Iced ❄️' : 'Hot ☕',
      cupSize,
      sugarLevel,
      milkOption,
      if (extraShot) '+1 Espresso Shot',
    ];
    return parts.join(' • ');
  }
}

/// Model Outlet Kopi B
class OutletStore {
  const OutletStore({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceKm,
    required this.prepMinutes,
    required this.isOpen,
    this.hasDriveThru = false,
  });

  final String id;
  final String name;
  final String address;
  final double distanceKm;
  final int prepMinutes;
  final bool isOpen;
  final bool hasDriveThru;
}

/// Model Voucher Promo & Reward
class PromoVoucher {
  const PromoVoucher({
    required this.id,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.discountAmount,
    required this.minOrder,
    required this.validUntil,
    this.beansCost = 0,
  });

  final String id;
  final String code;
  final String title;
  final String subtitle;
  final int discountAmount;
  final int minOrder;
  final String validUntil;
  final int beansCost;
}

/// Model Pesanan (Aktif maupun Riwayat)
class CoffeeOrder {
  CoffeeOrder({
    required this.id,
    required this.createdAt,
    required this.outlet,
    required this.mode,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.paymentMethod,
    required this.earnedBeans,
    this.stage = OrderStage.brewing,
    this.isCompleted = false,
    this.pickupCode = 'KB-084',
  });

  final String id;
  final String createdAt;
  final OutletStore outlet;
  final OrderMode mode;
  final List<CartItem> items;
  final int subtotal;
  final int discount;
  final String paymentMethod;
  final int earnedBeans;
  OrderStage stage;
  bool isCompleted;
  final String pickupCode;

  int get total => (subtotal - discount).clamp(0, 9999999);
}

/// Helper pemformat mata uang Rupiah
String formatRupiah(int amount) {
  final str = amount.toString();
  final buffer = StringBuffer('Rp ');
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(str[i]);
  }
  return buffer.toString();
}

