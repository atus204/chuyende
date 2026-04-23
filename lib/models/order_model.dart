import 'cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  delivering,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
        return 'Đã xác nhận';
      case OrderStatus.preparing:
        return 'Đang chuẩn bị';
      case OrderStatus.delivering:
        return 'Đang giao hàng';
      case OrderStatus.delivered:
        return 'Đã giao';
      case OrderStatus.cancelled:
        return 'Đã huỷ';
    }
  }
}

enum PaymentMethod { cash, momo, vnpay }

extension PaymentMethodExtension on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return 'Tiền mặt';
      case PaymentMethod.momo:
        return 'Ví Momo';
      case PaymentMethod.vnpay:
        return 'VNPay';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.cash:
        return '💵';
      case PaymentMethod.momo:
        return '💜';
      case PaymentMethod.vnpay:
        return '💳';
    }
  }
}

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final DateTime createdAt;
  OrderStatus status;
  final String address;
  final PaymentMethod paymentMethod;
  final String? note;

  OrderModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.createdAt,
    required this.status,
    required this.address,
    required this.paymentMethod,
    this.note,
  });

  String get formattedTotal {
    return '${total.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}đ';
  }

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);
}
