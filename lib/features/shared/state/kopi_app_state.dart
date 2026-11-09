import 'package:flutter/material.dart';
import '../models/kopi_models.dart';

/// State terpusat untuk aplikasi "Kopi B" (#kopiyangbaik)
class KopiAppState extends ChangeNotifier {
  KopiAppState() {
    _initSampleData();
  }

  // ─── Navigasi & Profil Pengguna ────────────────────────────────────────────
  int currentTabIndex = 0;
  String userName = 'Raka Pratama';
  String memberTier = 'Botanical Brewer';
  int bBeansPoints = 145;
  final int nextFreeCupTarget = 200;
  int stampCount = 6; // dari 8 stamp untuk gratis 1 cup
  int savedPlasticCups = 14;
  bool bringOwnTumbler = false;
  String selectedPaymentMethod = 'GoPay (Rp 185.000)';
  String deliveryAddress = 'Jl. Senopati Dalam No. 18, Kebayoran Baru, Jakarta Selatan';

  // ─── Mode Pemesanan & Outlet ───────────────────────────────────────────────
  OrderMode orderMode = OrderMode.pickUp;
  late OutletStore selectedOutlet;
  late final List<OutletStore> outlets;

  // ─── Katalog Menu, Keranjang, Voucher, dan Pesanan ─────────────────────────
  late final List<CoffeeProduct> products;
  final List<CartItem> cart = [];
  late final List<PromoVoucher> vouchers;
  PromoVoucher? appliedVoucher;
  final List<CoffeeOrder> orders = [];

  void _initSampleData() {
    outlets = const [
      OutletStore(
        id: 'senopati',
        name: 'Kopi B Senopati Flagship',
        address: 'Jl. Senopati No. 42, Jakarta Selatan',
        distanceKm: 0.8,
        prepMinutes: 5,
        isOpen: true,
        hasDriveThru: true,
      ),
      OutletStore(
        id: 'menteng',
        name: 'Kopi B Menteng Botanical',
        address: 'Jl. HOS. Cokroaminoto No. 78, Menteng',
        distanceKm: 2.3,
        prepMinutes: 7,
        isOpen: true,
      ),
      OutletStore(
        id: 'bsd',
        name: 'Kopi B Green Office Park BSD',
        address: 'The Breeze BSD City, Tangerang',
        distanceKm: 4.5,
        prepMinutes: 6,
        isOpen: true,
        hasDriveThru: true,
      ),
    ];
    selectedOutlet = outlets.first;

    products = const [
      CoffeeProduct(
        id: 'aren-botanical',
        name: 'Aren Botanical Latte',
        description:
            '100% Arabica Gayo berpadu dengan gula aren organik hangat dan susu segar creamy.',
        price: 29000,
        originalPrice: 34000,
        category: MenuCategory.signature,
        calories: 165,
        rating: 4.9,
        accentColor: Color(0xFF0D6B4C),
        cupColor: Color(0xFFC68B59),
        badgeText: 'BEST SELLER',
        isBestSeller: true,
      ),
      CoffeeProduct(
        id: 'pandan-cloud',
        name: 'Pandan Cloud Cold Brew',
        description:
            'Cold brew 16 jam dengan ekstrak daun pandan asli dan sweet botanical cream foam.',
        price: 33000,
        category: MenuCategory.signature,
        calories: 140,
        rating: 4.9,
        accentColor: Color(0xFF1EB986),
        cupColor: Color(0xFF4E9F76),
        badgeText: 'SIGNATURE',
        isBestSeller: true,
      ),
      CoffeeProduct(
        id: 'butterscotch-sea-salt',
        name: 'Butterscotch Sea Salt Latte',
        description:
            'Rasa karamel butterscotch gurih dengan taburan French sea salt di atas ristretto ganda.',
        price: 34000,
        category: MenuCategory.signature,
        calories: 190,
        rating: 4.8,
        accentColor: Color(0xFF8C5828),
        cupColor: Color(0xFFD7995B),
        badgeText: 'FAVORIT',
        isBestSeller: true,
      ),
      CoffeeProduct(
        id: 'oat-honey-cap',
        name: 'Oat Honey Cinnamon Latte',
        description:
            'Susu gandum (Oat Milk) ramah lingkungan dengan madu hutan murni dan sentuhan kayu manis.',
        price: 36000,
        originalPrice: 40000,
        category: MenuCategory.oatSeries,
        calories: 130,
        rating: 4.9,
        accentColor: Color(0xFF28E5A7),
        cupColor: Color(0xFFD5B887),
        badgeText: 'PLANT-BASED',
        isBestSeller: true,
        isOatDefault: true,
      ),
      CoffeeProduct(
        id: 'oat-shaken-espresso',
        name: 'Iced Brown Sugar Oat Shaken',
        description:
            'Double shot espresso dikocok bersama brown sugar dan es, dituang dengan oat milk segar.',
        price: 35000,
        category: MenuCategory.oatSeries,
        calories: 125,
        rating: 4.8,
        accentColor: Color(0xFF0D6B4C),
        cupColor: Color(0xFFB38867),
        isOatDefault: true,
      ),
      CoffeeProduct(
        id: 'manuka-americano',
        name: 'Manuka Citrus Americano',
        description:
            'Espresso Arabica cerah dengan madu Manuka dan kesegaran kulit jeruk sunkist.',
        price: 27000,
        category: MenuCategory.espresso,
        calories: 45,
        rating: 4.7,
        accentColor: Color(0xFF05452E),
        cupColor: Color(0xFF6B3E26),
        badgeText: 'LOW CALORIE',
      ),
      CoffeeProduct(
        id: 'classic-caffe-latte',
        name: 'Artisanal Caffè Latte',
        description:
            'Keseimbangan klasik antara single-origin espresso lembut dengan silky steamed milk.',
        price: 28000,
        category: MenuCategory.espresso,
        calories: 120,
        rating: 4.8,
        accentColor: Color(0xFF0D6B4C),
        cupColor: Color(0xFFC89F78),
        defaultIced: false,
      ),
      CoffeeProduct(
        id: 'matcha-forest-latte',
        name: 'Uji Matcha Forest Latte',
        description:
            'Pure ceremonial grade Uji Matcha Jepang dengan tekstur umami lembut dan creamy.',
        price: 33000,
        category: MenuCategory.nonCoffee,
        calories: 155,
        rating: 4.9,
        accentColor: Color(0xFF1EB986),
        cupColor: Color(0xFF5FA777),
        badgeText: 'PURE UJI',
      ),
      CoffeeProduct(
        id: 'dark-choco-mint',
        name: 'Botanical Mint Dark Choco',
        description:
            '70% Cokelat hitam Bali berpadu sensasi daun peppermint segar yang menenangkan.',
        price: 32000,
        category: MenuCategory.nonCoffee,
        calories: 180,
        rating: 4.7,
        accentColor: Color(0xFF05452E),
        cupColor: Color(0xFF543828),
      ),
      CoffeeProduct(
        id: 'almond-croissant',
        name: 'Butter Almond Croissant',
        description:
            'Croissant berlapis renyah dengan krim frangipane almond panggang setiap pagi.',
        price: 29000,
        category: MenuCategory.bakery,
        calories: 260,
        rating: 4.9,
        accentColor: Color(0xFFB67D3E),
        cupColor: Color(0xFFE0A96D),
        badgeText: 'FRESH BAKED',
        supportsCustomization: false,
      ),
      CoffeeProduct(
        id: 'matcha-canele',
        name: 'Kopi B Espresso Canelé',
        description:
            'Pastry klasik Bordeaux dengan kulit karamel renyah dan bagian dalam lembut beraroma kopi.',
        price: 24000,
        category: MenuCategory.bakery,
        calories: 195,
        rating: 4.8,
        accentColor: Color(0xFF6B4226),
        cupColor: Color(0xFF8C5332),
        supportsCustomization: false,
      ),
    ];

    vouchers = const [
      PromoVoucher(
        id: 'v-welcome50',
        code: 'KOPIYANGBAIK',
        title: 'Diskon 30% #kopiyangbaik',
        subtitle: 'Potongan Rp 12.000 untuk semua menu Signature & Oat Series',
        discountAmount: 12000,
        minOrder: 28000,
        validUntil: 'Berlaku hari ini',
      ),
      PromoVoucher(
        id: 'v-tumbler',
        code: 'ECOTUMBLER',
        title: 'Voucher Eco-Tumbler Rp 5.000',
        subtitle: 'Bawa tumbler sendiri saat Pick-Up & kurangi sampah plastik',
        discountAmount: 5000,
        minOrder: 20000,
        validUntil: 'Setiap Hari',
      ),
      PromoVoucher(
        id: 'v-freecup',
        code: 'FREEBBEANS',
        title: 'Gratis 1 Cup Signature Kopi B',
        subtitle: 'Tukarkan 100 B-Beans untuk gratis minuman hingga Rp 34.000',
        discountAmount: 29000,
        minOrder: 29000,
        validUntil: 'Tersedia dengan 100 B-Beans',
        beansCost: 100,
      ),
    ];

    appliedVoucher = vouchers.first;

    // Keranjang awal kosong (tidak memunculkan floating checkout bar)

    // 1 pesanan aktif sedang diseduh barista & 1 riwayat pesanan selesai
    orders.addAll([
      CoffeeOrder(
        id: 'ORD-9841',
        createdAt: 'Hari ini, 16:20 WIB',
        outlet: selectedOutlet,
        mode: OrderMode.pickUp,
        items: [
          CartItem(
            product: products[1], // Pandan Cloud Cold Brew
            quantity: 1,
            isIced: true,
            sugarLevel: 'Less Sugar',
          ),
          CartItem(
            product: products[9], // Butter Almond Croissant
            quantity: 1,
          ),
        ],
        subtotal: 62000,
        discount: 12000,
        paymentMethod: 'GoPay',
        earnedBeans: 15,
        stage: OrderStage.brewing,
        isCompleted: false,
        pickupCode: 'KB-209',
      ),
      CoffeeOrder(
        id: 'ORD-9710',
        createdAt: 'Kemarin, 08:45 WIB',
        outlet: outlets[1],
        mode: OrderMode.pickUp,
        items: [
          CartItem(
            product: products[0], // Aren Botanical Latte
            quantity: 2,
            isIced: true,
            sugarLevel: 'Normal Sugar',
          ),
        ],
        subtotal: 58000,
        discount: 5000,
        paymentMethod: 'QRIS',
        earnedBeans: 12,
        stage: OrderStage.ready,
        isCompleted: true,
        pickupCode: 'KB-114',
      ),
    ]);
  }

  // ─── Getters ───────────────────────────────────────────────────────────────
  int get totalCartItems =>
      cart.fold<int>(0, (sum, item) => sum + item.quantity);

  int get cartSubtotal =>
      cart.fold<int>(0, (sum, item) => sum + item.totalPrice);

  int get tumblerDiscount => (bringOwnTumbler && cart.isNotEmpty) ? 5000 : 0;

  int get voucherDiscount {
    if (appliedVoucher == null || cart.isEmpty) return 0;
    if (cartSubtotal < appliedVoucher!.minOrder) return 0;
    return appliedVoucher!.discountAmount;
  }

  int get cartTotal =>
      (cartSubtotal - voucherDiscount - tumblerDiscount).clamp(0, 9999999);

  int get activeOrderCount => orders.where((o) => !o.isCompleted).length;

  // ─── Actions ───────────────────────────────────────────────────────────────
  void setTabIndex(int index) {
    if (currentTabIndex == index) return;
    currentTabIndex = index;
    notifyListeners();
  }

  void setOrderMode(OrderMode mode) {
    orderMode = mode;
    notifyListeners();
  }

  void selectOutlet(OutletStore outlet) {
    selectedOutlet = outlet;
    notifyListeners();
  }

  void toggleBringOwnTumbler(bool value) {
    bringOwnTumbler = value;
    notifyListeners();
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  void applyVoucher(PromoVoucher? voucher) {
    appliedVoucher = voucher;
    notifyListeners();
  }

  void addToCart(CartItem newItem) {
    final existingIndex = cart.indexWhere(
      (item) =>
          item.product.id == newItem.product.id &&
          item.isIced == newItem.isIced &&
          item.sugarLevel == newItem.sugarLevel &&
          item.milkOption == newItem.milkOption &&
          item.cupSize == newItem.cupSize &&
          item.extraShot == newItem.extraShot,
    );

    if (existingIndex >= 0) {
      cart[existingIndex].quantity += newItem.quantity;
    } else {
      cart.add(newItem);
    }
    notifyListeners();
  }

  void updateCartQuantity(int index, int delta) {
    if (index < 0 || index >= cart.length) return;
    cart[index].quantity += delta;
    if (cart[index].quantity <= 0) {
      cart.removeAt(index);
    }
    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  /// Proses Checkout membuat pesanan aktif baru dan menambah poin B-Beans
  CoffeeOrder? checkoutOrder() {
    if (cart.isEmpty) return null;

    final subtotal = cartSubtotal;
    final totalDiscount = voucherDiscount + tumblerDiscount;
    final earned = ((subtotal - totalDiscount) / 3500).round().clamp(5, 50);

    if (appliedVoucher != null && appliedVoucher!.beansCost > 0) {
      bBeansPoints = (bBeansPoints - appliedVoucher!.beansCost).clamp(0, 99999);
    }

    bBeansPoints += earned;
    stampCount = (stampCount + totalCartItems) % 8;
    if (bringOwnTumbler) {
      savedPlasticCups += totalCartItems;
    }

    final newOrder = CoffeeOrder(
      id: 'ORD-${9842 + orders.length}',
      createdAt: 'Baru saja',
      outlet: selectedOutlet,
      mode: orderMode,
      items: List<CartItem>.from(cart),
      subtotal: subtotal,
      discount: totalDiscount,
      paymentMethod: selectedPaymentMethod.split(' ').first,
      earnedBeans: earned,
      stage: OrderStage.received,
      isCompleted: false,
      pickupCode: 'KB-${210 + orders.length}',
    );

    orders.insert(0, newOrder);
    cart.clear();
    currentTabIndex = 2; // Arahkan ke tab Order untuk memantau proses barista
    notifyListeners();
    return newOrder;
  }

  /// Simulasi kemajuan status barista pada pesanan aktif
  void advanceOrderStage(String orderId) {
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index < 0) return;
    final order = orders[index];
    if (order.stage == OrderStage.received) {
      order.stage = OrderStage.brewing;
    } else if (order.stage == OrderStage.brewing) {
      order.stage = OrderStage.ready;
    } else {
      order.isCompleted = true;
    }
    notifyListeners();
  }

  /// Reorder satu ketukan dari riwayat pesanan
  void reorderFromHistory(CoffeeOrder pastOrder) {
    for (final item in pastOrder.items) {
      addToCart(
        CartItem(
          product: item.product,
          quantity: item.quantity,
          isIced: item.isIced,
          sugarLevel: item.sugarLevel,
          milkOption: item.milkOption,
          cupSize: item.cupSize,
          extraShot: item.extraShot,
        ),
      );
    }
    currentTabIndex = 1; // Buka tab Menu dengan keranjang siap checkout
    notifyListeners();
  }
}

