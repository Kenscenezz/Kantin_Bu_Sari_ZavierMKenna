import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/kantin_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with SingleTickerProviderStateMixin {
  final KantinService _service = KantinService();
  late TabController _tabController;

  String _orderType = 'Makan di Tempat';
  final TextEditingController _tableController = TextEditingController(text: 'Meja 04');
  final TextEditingController _promoController = TextEditingController();
  String _paymentMethod = 'KantinPay';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    _tabController.dispose();
    _tableController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  void _confirmCheckout() {
    if (_service.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang Anda kosong!')),
      );
      return;
    }

    if (_paymentMethod == 'KantinPay' && _service.userBalance < _service.cartGrandTotal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo KantinPay tidak cukup! Silakan ganti metode atau top up.'), backgroundColor: Colors.red),
      );
      return;
    }

    final newOrder = _service.checkout(
      orderType: _orderType,
      tableNumber: _orderType == 'Makan di Tempat' ? _tableController.text.trim() : '-',
      paymentMethod: _paymentMethod,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 12),
            const Text(
              'Pesanan Kamu Diterima!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Kode Antrean: ${newOrder.orderCode}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tunjukkan struk digital ini ke kasir Bu Sari saat mengambil pesanan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx);
                _tabController.animateTo(1); // Beralih ke tab pelacakan status
              },
              icon: const Icon(Icons.track_changes),
              label: const Text('Pantau Status Pesanan'),
            ),
          ],
        ),
      ),
    );
  }

  void _advanceOrderStep(OrderModel order) {
    OrderStatus next;
    switch (order.status) {
      case OrderStatus.diterima:
        next = OrderStatus.dimasak;
        break;
      case OrderStatus.dimasak:
        next = OrderStatus.siapDiambil;
        break;
      case OrderStatus.siapDiambil:
        next = OrderStatus.selesai;
        break;
      case OrderStatus.selesai:
        return;
    }
    _service.updateOrderStatus(order.orderCode, next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Bu Sari - Pesanan Kamu'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Keranjang (${_service.cartCount})'),
            Tab(text: 'Status Antrean (${_service.orders.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: KERANJANG & CHECKOUT
          _buildCartTab(),

          // TAB 2: PELACAKAN & STATUS ANTURAN (Struk Digital)
          _buildTrackingTab(),
        ],
      ),
    );
  }

  Widget _buildCartTab() {
    if (_service.cart.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 70, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'Belum Ada Pesanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Yuk pilih hidangan enak dan minuman segar di menu Bu Sari!'),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                icon: const Icon(Icons.home),
                label: const Text('Kembali ke Daftar Menu'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. SegmentedButton Tipe Pesanan
          Center(
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Makan di Tempat', icon: Icon(Icons.dining), label: Text('Dine In')),
                ButtonSegment(value: 'Bawa Pulang', icon: Icon(Icons.takeout_dining), label: Text('Bungkus')),
              ],
              selected: {_orderType},
              onSelectionChanged: (val) => setState(() => _orderType = val.first),
            ),
          ),
          const SizedBox(height: 12),

          // 2. TextFormField Nomor Meja
          if (_orderType == 'Makan di Tempat') ...[
            TextFormField(
              controller: _tableController,
              decoration: const InputDecoration(
                labelText: 'Nomor Meja',
                prefixIcon: Icon(Icons.place, color: Colors.deepOrange),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // 3. Dismissible List Pesanan
          const Text('Daftar Menu yang Dipesan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          ..._service.cart.map((cartItem) {
            return Dismissible(
              key: Key(cartItem.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) => _service.removeFromCart(cartItem.id),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cartItem.item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(
                              'Porsi: ${cartItem.portionSize} • Level ${cartItem.spicinessLevel}',
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                            if (cartItem.toppings.isNotEmpty)
                              Text('Topping: ${cartItem.toppings.join(', ')}', style: const TextStyle(fontSize: 11, color: Colors.deepOrange)),
                            if (cartItem.note.isNotEmpty)
                              Text('Catatan: "${cartItem.note}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                            const SizedBox(height: 4),
                            Text(KantinService.formatRupiah(cartItem.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 20),
                            onPressed: () => _service.updateQuantity(cartItem.id, -1),
                          ),
                          Text('${cartItem.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 20),
                            onPressed: () => _service.updateQuantity(cartItem.id, 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),

          // 4. TextField + Button Klaim Kupon
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kupon Diskon Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          decoration: const InputDecoration(
                            hintText: 'Cth: MAHASISWAHEMAT',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final ok = _service.applyPromo(_promoController.text);
                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voucher berhasil digunakan!')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kupon tidak valid!')));
                          }
                        },
                        child: const Text('Klaim'),
                      ),
                    ],
                  ),
                  if (_service.appliedPromoCode.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text('Hemat ${KantinService.formatRupiah(_service.discountAmount)} aktif!', style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          TextButton(onPressed: () => _service.removePromo(), child: const Text('Hapus', style: TextStyle(fontSize: 11))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 5. RadioListTile Pembayaran
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  RadioListTile<String>(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('KantinPay (Dompet Digital)', style: TextStyle(fontSize: 13)),
                        Text(KantinService.formatRupiah(_service.userBalance), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    value: 'KantinPay',
                    groupValue: _paymentMethod,
                    activeColor: Colors.deepOrange,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _paymentMethod = val!),
                  ),
                  RadioListTile<String>(
                    title: const Text('QRIS (BCA, GoPay, OVO, Shopee)', style: TextStyle(fontSize: 13)),
                    value: 'QRIS',
                    groupValue: _paymentMethod,
                    activeColor: Colors.deepOrange,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _paymentMethod = val!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Bayar Tunai di Kasir Bu Sari', style: TextStyle(fontSize: 13)),
                    value: 'Bayar di Kasir',
                    groupValue: _paymentMethod,
                    activeColor: Colors.deepOrange,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _paymentMethod = val!),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Rincian Biaya
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(color: Colors.black54)),
                      Text(KantinService.formatRupiah(_service.cartSubtotal)),
                    ],
                  ),
                  if (_service.discountAmount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Potongan Diskon', style: TextStyle(color: Colors.green)),
                        Text('- ${KantinService.formatRupiah(_service.discountAmount)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        KantinService.formatRupiah(_service.cartGrandTotal),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.deepOrange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tombol Konfirmasi Pesanan & Tombol Kembali
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
              onPressed: _confirmCheckout,
              child: Text(
                'Konfirmasi & Buat Pesanan (${KantinService.formatRupiah(_service.cartGrandTotal)})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar Menu'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTrackingTab() {
    final orders = _service.orders;
    if (orders.isEmpty) {
      return const Center(child: Text('Belum ada pesanan aktif.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (ctx, idx) {
        final order = orders[idx];
        final progress = (order.statusStep + 1) / 4;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.circular(6)),
                      child: Text(order.orderCode, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    Text('${order.orderType} • ${order.tableNumber}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 10),

                // 6. LinearProgressIndicator & Stepper
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.statusText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: progress, color: Colors.deepOrange, backgroundColor: Colors.grey.shade200),
                const SizedBox(height: 12),

                Stepper(
                  physics: const NeverScrollableScrollPhysics(),
                  currentStep: order.statusStep,
                  controlsBuilder: (_, __) => const SizedBox.shrink(),
                  steps: [
                    Step(title: const Text('Pesanan Diterima'), content: const SizedBox.shrink(), isActive: order.statusStep >= 0),
                    Step(title: const Text('Sedang Dimasak Bu Sari'), content: const SizedBox.shrink(), isActive: order.statusStep >= 1),
                    Step(title: const Text('Siap Diambil di Konter'), content: const SizedBox.shrink(), isActive: order.statusStep >= 2),
                    Step(title: const Text('Pesanan Selesai'), content: const SizedBox.shrink(), isActive: order.statusStep >= 3),
                  ],
                ),

                const Divider(),
                ...order.items.map((it) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${it.quantity}x ${it.item.name}', style: const TextStyle(fontSize: 12)),
                          Text(KantinService.formatRupiah(it.totalPrice), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pembayaran', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    Text(KantinService.formatRupiah(order.totalAmount), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  ],
                ),
                const SizedBox(height: 12),

                // Tombol Simulasi Lanjut Step (untuk demonstrasi dosen)
                if (order.status != OrderStatus.selesai)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _advanceOrderStep(order),
                      icon: const Icon(Icons.fast_forward, size: 16),
                      label: const Text('Simulasi Lanjut Status', style: TextStyle(fontSize: 12)),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
