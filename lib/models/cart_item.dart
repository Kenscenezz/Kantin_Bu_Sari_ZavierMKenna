import 'menu_item.dart';

class CartItem {
  final String id;
  final MenuItem item;
  int quantity;
  int spicinessLevel;
  String portionSize;
  List<String> toppings;
  String note;

  CartItem({
    required this.id,
    required this.item,
    this.quantity = 1,
    this.spicinessLevel = 1,
    this.portionSize = 'Reguler',
    List<String>? toppings,
    this.note = '',
  }) : toppings = toppings ?? [];

  int get portionExtra => portionSize.contains('Jumbo') ? 3000 : 0;
  int get toppingsExtra => toppings.length * 2000;
  int get unitPrice => item.price + portionExtra + toppingsExtra;
  int get totalPrice => unitPrice * quantity;
}
