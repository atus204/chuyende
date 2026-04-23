import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';
import '../models/order_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<OrderModel> _orders = [];
  double _deliveryFee = 20000;
  double _discount = 0;

  List<CartItem> get items => List.unmodifiable(_items);
  List<OrderModel> get orders => List.unmodifiable(_orders);
  double get deliveryFee => _deliveryFee;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discount => _discount;

  double get total => subtotal + _deliveryFee - _discount;

  bool get isEmpty => _items.isEmpty;

  bool containsFood(String foodId) =>
      _items.any((item) => item.foodItem.id == foodId);

  int quantityOf(String foodId) {
    final idx = _items.indexWhere((item) => item.foodItem.id == foodId);
    return idx >= 0 ? _items[idx].quantity : 0;
  }

  void addItem(FoodItem food, {int quantity = 1, String? note}) {
    final idx = _items.indexWhere((item) => item.foodItem.id == food.id);
    if (idx >= 0) {
      _items[idx].quantity += quantity;
    } else {
      _items.add(CartItem(foodItem: food, quantity: quantity, note: note));
    }
    notifyListeners();
  }

  void removeItem(String foodId) {
    _items.removeWhere((item) => item.foodItem.id == foodId);
    notifyListeners();
  }

  void increaseQuantity(String foodId) {
    final idx = _items.indexWhere((item) => item.foodItem.id == foodId);
    if (idx >= 0) {
      _items[idx].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String foodId) {
    final idx = _items.indexWhere((item) => item.foodItem.id == foodId);
    if (idx >= 0) {
      if (_items[idx].quantity > 1) {
        _items[idx].quantity--;
      } else {
        _items.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _discount = 0;
    notifyListeners();
  }

  void applyDiscount(String code) {
    if (code.toUpperCase() == 'GIAM20') {
      _discount = subtotal * 0.2;
    } else if (code.toUpperCase() == 'FREESHIP') {
      _deliveryFee = 0;
    } else if (code.toUpperCase() == 'COMBO4') {
      _discount = 50000;
    }
    notifyListeners();
  }

  OrderModel placeOrder({
    required String address,
    required PaymentMethod paymentMethod,
    String? note,
  }) {
    final order = OrderModel(
      id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(_items),
      subtotal: subtotal,
      deliveryFee: _deliveryFee,
      discount: _discount,
      total: total,
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
      address: address,
      paymentMethod: paymentMethod,
      note: note,
    );
    _orders.insert(0, order);
    clearCart();
    _deliveryFee = 20000;
    return order;
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _orders[idx].status = status;
      notifyListeners();
    }
  }
}
