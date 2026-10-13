import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/cart_item.dart';
import '../services/kantin_service.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({super.key});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final KantinService _service = KantinService();
  int _quantity = 1;
  double _spicinessLevel = 1.0;
  String _portion = 'Reguler';
  final List<String> _selectedToppings = [];
  final TextEditingController _noteController = TextEditingController();

  final List<String> _availableToppings = [
    'Telur Dadar / Ceplok (+Rp 2.000)',
    'Kerupuk Kaleng (+Rp 2.000)',
    'Ekstra Sambal Korek (+Rp 2.000)',
    'Tahu Tempe Goreng (+Rp 2.000)',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _getSpicyLabel(int lvl) {
    switch (lvl) {
      case 0:
        return 'Level 0 (Tanpa Cabai)';
      case 1:
        return 'Level 1 (Pedas Manis)';
      case 2:
        return 'Level 2 (Sedang)';
      case 3:
        return 'Level 3 (Pedas Nikmat)';
      case 4:
        return 'Level 4 (Pedas Nampol)';
      case 5:
        return 'Level 5 (Super Pedas 🔥)';
      default:
        return 'Level $lvl';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil item dari arguments jika ada, atau fallback ke menu pertama
    final args = ModalRoute.of(context)?.settings.arguments;
    final MenuItem item = (args is MenuItem) ? args : _service.menuList.first;
    final isFav = _service.isFavorite(item.id);

    int unitPrice = item.price;
    if (_portion.contains('Jumbo')) unitPrice += 3000;
    unitPrice += _selectedToppings.length * 2000;
    final int totalPrice = unitPrice * _quantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            onPressed: () {
              _service.toggleFavorite(item.id);
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/pesan'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Utama Menu
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.deepOrange.shade50,
                  child: const Icon(Icons.restaurant, size: 60, color: Colors.deepOrange),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul & Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        KantinService.formatRupiah(item.price),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.deepOrange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Kategori & Rating
                  Row(
                    children: [
                      Chip(
                        label: Text(item.category, style: const TextStyle(fontSize: 11)),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${item.rating} (${item.reviewCount} ulasan)', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      const Spacer(),
                      const Icon(Icons.timer_outlined, size: 14, color: Colors.black54),
                      Text(' ${item.prepTimeMinutes} menit', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Deskripsi
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                  ),
                  const Divider(height: 28),

                  // 1. Slider: Tingkat Pedas
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.local_fire_department, color: Colors.deepOrange, size: 20),
                                  SizedBox(width: 6),
                                  Text('Tingkat Kepedasan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                              Text(
                                _getSpicyLabel(_spicinessLevel.round()),
                                style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                          Slider(
                            value: _spicinessLevel,
                            min: 0,
                            max: 5,
                            divisions: 5,
                            activeColor: Colors.deepOrange,
                            label: 'Level ${_spicinessLevel.round()}',
                            onChanged: (val) => setState(() => _spicinessLevel = val),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 2. RadioListTile: Ukuran Porsi
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.rice_bowl, color: Colors.deepOrange, size: 20),
                              SizedBox(width: 6),
                              Text('Pilihan Porsi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          RadioListTile<String>(
                            title: const Text('Porsi Reguler (Standar)', style: TextStyle(fontSize: 13)),
                            value: 'Reguler',
                            groupValue: _portion,
                            activeColor: Colors.deepOrange,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) => setState(() => _portion = val!),
                          ),
                          RadioListTile<String>(
                            title: const Text('Porsi Jumbo (+Rp 3.000)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            value: 'Jumbo (+Rp 3.000)',
                            groupValue: _portion,
                            activeColor: Colors.deepOrange,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) => setState(() => _portion = val!),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. CheckboxListTile: Topping Tambahan
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.add_circle_outline, color: Colors.deepOrange, size: 20),
                              SizedBox(width: 6),
                              Text('Topping Tambahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          ..._availableToppings.map((top) {
                            final checked = _selectedToppings.contains(top);
                            return CheckboxListTile(
                              title: Text(top, style: const TextStyle(fontSize: 13)),
                              value: checked,
                              activeColor: Colors.deepOrange,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedToppings.add(top);
                                  } else {
                                    _selectedToppings.remove(top);
                                  }
                                });
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 4. TextField: Catatan Khusus
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.edit_note, color: Colors.deepOrange, size: 20),
                              SizedBox(width: 6),
                              Text('Catatan Khusus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _noteController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              hintText: 'Cth: Jangan pakai seledri, kuah dipisah, timun diperbanyak...',
                              hintStyle: TextStyle(fontSize: 12),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // 5. Counter Quantity
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16),
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                    ),
                    Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    IconButton(
                      icon: const Icon(Icons.add, size: 16),
                      onPressed: () => setState(() => _quantity++),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // 6. Tombol Pesan Sekarang (Sesuai action starter repo: menuju /pesan)
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    final cartItem = CartItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      item: item,
                      quantity: _quantity,
                      spicinessLevel: _spicinessLevel.round(),
                      portionSize: _portion,
                      toppings: List.from(_selectedToppings),
                      note: _noteController.text.trim(),
                    );
                    _service.addToCart(cartItem);
                    Navigator.pushNamed(context, '/pesan');
                  },
                  icon: const Icon(Icons.shopping_cart, size: 18),
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Pesan Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(KantinService.formatRupiah(totalPrice), style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
