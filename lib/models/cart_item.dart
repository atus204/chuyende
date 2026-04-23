import 'food_item.dart';

class CartItem {
  final FoodItem foodItem;
  int quantity;
  String? note;

  CartItem({
    required this.foodItem,
    this.quantity = 1,
    this.note,
  });

  double get totalPrice => foodItem.price * quantity;

  String get formattedTotalPrice {
    return '${totalPrice.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}đ';
  }

  CartItem copyWith({
    FoodItem? foodItem,
    int? quantity,
    String? note,
  }) {
    return CartItem(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
