import 'cart_item.dart';

enum OrderStatus {
  diterima,
  dimasak,
  siapDiambil,
  selesai,
}

class OrderModel {
  final String orderCode;
  final List<CartItem> items;
  final String orderType;
  final String tableNumber;
  final String paymentMethod;
  final int subtotal;
  final int discount;
  final int totalAmount;
  final DateTime createdAt;
  OrderStatus status;

  OrderModel({
    required this.orderCode,
    required this.items,
    required this.orderType,
    required this.tableNumber,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.totalAmount,
    required this.createdAt,
    this.status = OrderStatus.diterima,
  });

  String get statusText {
    switch (status) {
      case OrderStatus.diterima:
        return 'Pesanan Diterima';
      case OrderStatus.dimasak:
        return 'Sedang Dimasak Bu Sari';
      case OrderStatus.siapDiambil:
        return 'Siap Diambil di Konter';
      case OrderStatus.selesai:
        return 'Pesanan Selesai';
    }
  }

  int get statusStep {
    switch (status) {
      case OrderStatus.diterima:
        return 0;
      case OrderStatus.dimasak:
        return 1;
      case OrderStatus.siapDiambil:
        return 2;
      case OrderStatus.selesai:
        return 3;
    }
  }
}
