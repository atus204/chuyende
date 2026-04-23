import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../models/food_item.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final food = ModalRoute.of(context)!.settings.arguments as FoodItem;
    final cart = context.watch<CartProvider>();
    final inCart = cart.quantityOf(food.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero Image App Bar ─────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 18),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                  child: Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shopping_cart_outlined, color: AppColors.textDark, size: 20),
                      ),
                      if (cart.totalItems > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: Center(
                              child: Text('${cart.totalItems}',
                                  style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    food.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primary.withOpacity(0.15),
                      child: Icon(Icons.restaurant, size: 100, color: AppColors.primary),
                    ),
                  ),
                  // Bottom gradient
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black45],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Popular badge
                  if (food.isPopular)
                    Positioned(
                      bottom: 16,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text('🔥', style: TextStyle(fontSize: 14)),
                            SizedBox(width: 4),
                            Text('Món phổ biến',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.dark)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Body ────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + category
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(food.name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(food.category,
                            style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating & info row
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.accent, size: 18),
                      const SizedBox(width: 4),
                      Text('${food.rating}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(' (${food.reviewCount} đánh giá)',
                          style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textGrey),
                      Text(' ${food.prepTimeMinutes} phút',
                          style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Text(food.formattedPrice,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary)),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Description
                  const Text('Mô tả món ăn',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Text(food.description,
                      style: const TextStyle(fontSize: 14, color: AppColors.textMedium, height: 1.6)),
                  const SizedBox(height: 16),

                  // Tags
                  if (food.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: food.tags
                          .map((t) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(t,
                                    style: const TextStyle(fontSize: 12, color: AppColors.accentDark, fontWeight: FontWeight.w500)),
                              ))
                          .toList(),
                    ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Số lượng',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      Row(
                        children: [
                          _qtyBtn(Icons.remove, () {
                            if (_quantity > 1) setState(() => _quantity--);
                          }),
                          Container(
                            width: 44,
                            alignment: Alignment.center,
                            child: Text('$_quantity',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                          ),
                          _qtyBtn(Icons.add, () => setState(() => _quantity++)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Note field
                  const Text('Ghi chú cho đầu bếp',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Ví dụ: ít cay, không hành, thêm tương...',
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Buttons
                  Row(
                    children: [
                      // Already in cart indicator
                      if (inCart > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.success.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.check, color: AppColors.success, size: 18),
                              Text('$inCart', style: const TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      Expanded(
                        child: CustomButton(
                          text: 'Thêm vào giỏ  •  ${_formatPrice(food.price * _quantity)}',
                          icon: Icons.shopping_cart_outlined,
                          onPressed: food.isAvailable
                              ? () {
                                  context.read<CartProvider>().addItem(food, quantity: _quantity, note: _noteCtrl.text);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: const Text('Đã thêm vào giỏ hàng 🛒'),
                                    backgroundColor: AppColors.success,
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ));
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Xem giỏ hàng',
                    isOutlined: true,
                    icon: Icons.arrow_forward,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
    );
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}đ';
  }
}
