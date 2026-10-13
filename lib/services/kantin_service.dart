import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../models/order_model.dart';

class KantinService extends ChangeNotifier {
  static final KantinService _instance = KantinService._internal();
  factory KantinService() => _instance;
  KantinService._internal();

  // Status Kantin
  bool isKantinOpen = true;
  void toggleKantinStatus() {
    isKantinOpen = !isKantinOpen;
    notifyListeners();
  }

  // Saldo Dompet Digital KantinPay
  int userBalance = 50000;
  void topUp(int amount) {
    userBalance += amount;
    notifyListeners();
  }

  // Favorites
  final Set<String> _favorites = {'1', '2', '6'};
  bool isFavorite(String id) => _favorites.contains(id);
  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners();
  }

  // Kode Voucher
  String appliedPromoCode = '';
  int discountAmount = 0;

  bool applyPromo(String code) {
    final clean = code.trim().toUpperCase();
    if (clean == 'MAHASISWAHEMAT') {
      appliedPromoCode = clean;
      discountAmount = 5000;
      notifyListeners();
      return true;
    } else if (clean == 'LABKOMKENYANG') {
      appliedPromoCode = clean;
      discountAmount = 7500;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    appliedPromoCode = '';
    discountAmount = 0;
    notifyListeners();
  }

  // Menu Items
  final List<MenuItem> menuList = [
    const MenuItem(
      id: '1',
      name: 'Ayam Geprek Sambal Korek',
      category: 'Makanan Utama',
      price: 15000,
      rating: 4.9,
      reviewCount: 342,
      imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600&auto=format&fit=crop&q=80',
      description: 'Ayam krispi renyah digeprek dengan cabai rawit pedas segar racikan Bu Sari. Disajikan lengkap dengan nasi pulen & timun.',
      prepTimeMinutes: 10,
      isAvailable: true,
      isSpicy: true,
      badge: 'Best Seller',
    ),
    const MenuItem(
      id: '2',
      name: 'Nasi Goreng Spesial Bu Sari',
      category: 'Makanan Utama',
      price: 14000,
      rating: 4.8,
      reviewCount: 220,
      imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=600&auto=format&fit=crop&q=80',
      description: 'Nasi goreng harum rempah tradisional dengan suwiran ayam, bakso, sosis, telur mata sapi, dan kerupuk renyah.',
      prepTimeMinutes: 12,
      isAvailable: true,
      badge: 'Favorit Mahasiswa',
    ),
    const MenuItem(
      id: '3',
      name: 'Soto Ayam Lamongan Gurih',
      category: 'Makanan Utama',
      price: 13000,
      rating: 4.7,
      reviewCount: 185,
      imageUrl: 'https://images.unsplash.com/photo-1572656639199-31129208199f?w=600&auto=format&fit=crop&q=80',
      description: 'Kuah kuning hangat berkaldu kaya rempah dengan koya gurih melimpah, soun, tauge, kol, dan sambal rawit.',
      prepTimeMinutes: 8,
      isAvailable: true,
      badge: 'Menu Hangat',
    ),
    const MenuItem(
      id: '4',
      name: 'Mie Dok-Dok Kuah Nyemek',
      category: 'Mie & Bakso',
      price: 12000,
      rating: 4.9,
      reviewCount: 289,
      imageUrl: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=600&auto=format&fit=crop&q=80',
      description: 'Mie kuning kenyal dimasak nyemek gurih pedas khas burjo/kantin malam, diselipi telur orak-arik dan sawi hijau.',
      prepTimeMinutes: 10,
      isAvailable: true,
      isSpicy: true,
      badge: 'Rekomendasi',
    ),
    const MenuItem(
      id: '5',
      name: 'Bakso Urat & Tahu Kuah',
      category: 'Mie & Bakso',
      price: 15000,
      rating: 4.6,
      reviewCount: 140,
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=600&auto=format&fit=crop&q=80',
      description: 'Bakso urat daging sapi asli bertekstur mantap, dilengkapi bakso halus, tahu bakso, tetelan empuk, dan pangsit goreng.',
      prepTimeMinutes: 7,
      isAvailable: true,
    ),
    const MenuItem(
      id: '6',
      name: 'Es Teh Manis Jumbo Segar',
      category: 'Minuman',
      price: 4000,
      rating: 4.9,
      reviewCount: 512,
      imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&auto=format&fit=crop&q=80',
      description: 'Teh melati wangi khas seduhan Bu Sari ukuran jumbo dingin menyegarkan, penawar dahaga setelah praktikum.',
      prepTimeMinutes: 3,
      isAvailable: true,
      badge: 'Murah Meriah',
    ),
    const MenuItem(
      id: '7',
      name: 'Es Jeruk Peras Murni',
      category: 'Minuman',
      price: 6000,
      rating: 4.8,
      reviewCount: 198,
      imageUrl: 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=600&auto=format&fit=crop&q=80',
      description: 'Perasan jeruk asli segar kaya vitamin C, manis pas dengan es batu segar.',
      prepTimeMinutes: 4,
      isAvailable: true,
    ),
    const MenuItem(
      id: '8',
      name: 'Tahu & Tempe Mendoan Crispy',
      category: 'Cemilan',
      price: 8000,
      rating: 4.7,
      reviewCount: 230,
      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80',
      description: 'Paket 4 pcs mendoan daun bawang hangat renyah di luar lembut di dalam, lengkap dengan cocolan sambal kecap pedas.',
      prepTimeMinutes: 6,
      isAvailable: true,
      badge: 'Cemilan Favorit',
    ),
    const MenuItem(
      id: '9',
      name: 'Pisang Bakar Coklat Keju',
      category: 'Cemilan',
      price: 9000,
      rating: 4.8,
      reviewCount: 110,
      imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=600&auto=format&fit=crop&q=80',
      description: 'Pisang kepok manis dipanggang harum mentega, ditaburi limpahan keju cheddar parut dan susu kental cokelat.',
      prepTimeMinutes: 8,
      isAvailable: true,
    ),
  ];

  // Keranjang
  final List<CartItem> cart = [];

  int get cartCount => cart.fold(0, (sum, it) => sum + it.quantity);
  int get cartSubtotal => cart.fold(0, (sum, it) => sum + it.totalPrice);
  int get cartGrandTotal {
    final sub = cartSubtotal;
    if (sub == 0) return 0;
    final total = sub - discountAmount;
    return total > 0 ? total : 0;
  }

  void addToCart(CartItem item) {
    final index = cart.indexWhere((c) =>
        c.item.id == item.item.id &&
        c.spicinessLevel == item.spicinessLevel &&
        c.portionSize == item.portionSize &&
        c.toppings.length == item.toppings.length &&
        c.toppings.every((t) => item.toppings.contains(t)));

    if (index >= 0) {
      cart[index].quantity += item.quantity;
    } else {
      cart.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(String cartId, int delta) {
    final idx = cart.indexWhere((c) => c.id == cartId);
    if (idx >= 0) {
      cart[idx].quantity += delta;
      if (cart[idx].quantity <= 0) {
        cart.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String cartId) {
    cart.removeWhere((c) => c.id == cartId);
    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    removePromo();
    notifyListeners();
  }

  // Riwayat & Pesanan Aktif
  final List<OrderModel> orders = [
    OrderModel(
      orderCode: 'KBS-1021',
      items: [
        CartItem(
          id: 'init-1',
          item: const MenuItem(
            id: '1',
            name: 'Ayam Geprek Sambal Korek',
            category: 'Makanan Utama',
            price: 15000,
            rating: 4.9,
            reviewCount: 342,
            imageUrl: '',
            description: '',
            prepTimeMinutes: 10,
          ),
          quantity: 1,
          spicinessLevel: 3,
        ),
      ],
      orderType: 'Makan di Tempat',
      tableNumber: 'Meja 04',
      paymentMethod: 'KantinPay',
      subtotal: 15000,
      discount: 0,
      totalAmount: 15000,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      status: OrderStatus.dimasak,
    ),
  ];

  OrderModel? get activeOrder {
    try {
      return orders.firstWhere((o) => o.status != OrderStatus.selesai);
    } catch (_) {
      return null;
    }
  }

  void updateOrderStatus(String code, OrderStatus newStatus) {
    final idx = orders.indexWhere((o) => o.orderCode == code);
    if (idx >= 0) {
      orders[idx].status = newStatus;
      notifyListeners();
    }
  }

  OrderModel checkout({
    required String orderType,
    required String tableNumber,
    required String paymentMethod,
  }) {
    final code = 'KBS-${1022 + orders.length}';
    final newOrder = OrderModel(
      orderCode: code,
      items: List.from(cart),
      orderType: orderType,
      tableNumber: tableNumber,
      paymentMethod: paymentMethod,
      subtotal: cartSubtotal,
      discount: discountAmount,
      totalAmount: cartGrandTotal,
      createdAt: DateTime.now(),
      status: OrderStatus.diterima,
    );

    if (paymentMethod == 'KantinPay' && userBalance >= cartGrandTotal) {
      userBalance -= cartGrandTotal;
    }

    orders.insert(0, newOrder);
    clearCart();
    notifyListeners();
    return newOrder;
  }

  static String formatRupiah(int number) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(number);
  }
}
