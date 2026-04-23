import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';
import '../models/order_model.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<CartItem> _items = [];
  List<OrderModel> _orders = [];
  double _deliveryFee = 20000;
  double _discount = 0;
  bool _isLoadingOrders = false;

  List<CartItem> get items => List.unmodifiable(_items);
  List<OrderModel> get orders => List.unmodifiable(_orders);
  double get deliveryFee => _deliveryFee;
  bool get isLoadingOrders => _isLoadingOrders;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get discount => _discount;
  double get total => subtotal + _deliveryFee - _discount;
  bool get isEmpty => _items.isEmpty;

  bool containsFood(String foodId) => _items.any((i) => i.foodItem.id == foodId);
  int quantityOf(String foodId) {
    final idx = _items.indexWhere((i) => i.foodItem.id == foodId);
    return idx >= 0 ? _items[idx].quantity : 0;
  }

  void addItem(FoodItem food, {int quantity = 1, String? note}) {
    final idx = _items.indexWhere((i) => i.foodItem.id == food.id);
    if (idx >= 0) {
      _items[idx].quantity += quantity;
    } else {
      _items.add(CartItem(foodItem: food, quantity: quantity, note: note));
    }
    notifyListeners();
  }

  void removeItem(String foodId) {
    _items.removeWhere((i) => i.foodItem.id == foodId);
    notifyListeners();
  }

  void increaseQuantity(String foodId) {
    final idx = _items.indexWhere((i) => i.foodItem.id == foodId);
    if (idx >= 0) { _items[idx].quantity++; notifyListeners(); }
  }

  void decreaseQuantity(String foodId) {
    final idx = _items.indexWhere((i) => i.foodItem.id == foodId);
    if (idx >= 0) {
      if (_items[idx].quantity > 1) { _items[idx].quantity--; }
      else { _items.removeAt(idx); }
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

  Future<OrderModel> placeOrder({
    required String userId,
    required String address,
    required PaymentMethod paymentMethod,
    String? note,
  }) async {
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

    // Lưu lên Firestore
    try {
      await _db.collection('orders').doc(order.id).set({
        'id': order.id,
        'userId': userId,
        'items': order.items.map((i) => {
          'foodId': i.foodItem.id,
          'foodName': i.foodItem.name,
          'foodImage': i.foodItem.imageUrl,
          'price': i.foodItem.price,
          'quantity': i.quantity,
          'note': i.note,
        }).toList(),
        'subtotal': order.subtotal,
        'deliveryFee': order.deliveryFee,
        'discount': order.discount,
        'total': order.total,
        'createdAt': FieldValue.serverTimestamp(),
        'status': order.status.name,
        'address': order.address,
        'paymentMethod': order.paymentMethod.name,
        'note': order.note,
      });
    } catch (e) {
      debugPrint('Error saving order: $e');
    }

    _orders.insert(0, order);
    clearCart();
    _deliveryFee = 20000;
    return order;
  }

  Future<void> loadOrders(String userId) async {
    _isLoadingOrders = true;
    notifyListeners();

    try {
      final snap = await _db
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _orders = snap.docs.map((doc) {
        final d = doc.data();
        final items = (d['items'] as List).map((i) => CartItem(
          foodItem: FoodItem(
            id: i['foodId'],
            name: i['foodName'],
            description: '',
            price: (i['price'] as num).toDouble(),
            imageUrl: i['foodImage'] ?? '',
            category: '',
          ),
          quantity: i['quantity'],
          note: i['note'],
        )).toList();

        return OrderModel(
          id: d['id'],
          items: items,
          subtotal: (d['subtotal'] as num).toDouble(),
          deliveryFee: (d['deliveryFee'] as num).toDouble(),
          discount: (d['discount'] as num).toDouble(),
          total: (d['total'] as num).toDouble(),
          createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          status: OrderStatus.values.firstWhere(
            (s) => s.name == d['status'],
            orElse: () => OrderStatus.pending,
          ),
          address: d['address'] ?? '',
          paymentMethod: PaymentMethod.values.firstWhere(
            (p) => p.name == d['paymentMethod'],
            orElse: () => PaymentMethod.cash,
          ),
          note: d['note'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading orders: $e');
    }

    _isLoadingOrders = false;
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _orders[idx].status = status;
      _db.collection('orders').doc(orderId).update({'status': status.name});
      notifyListeners();
    }
  }
}
