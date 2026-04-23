import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _voucherCtrl = TextEditingController();
  bool _voucherApplied = false;

  @override
  void dispose() {
    _voucherCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
        ),
        title: Column(
          children: [
            const Text(AppStrings.cart, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            if (cart.totalItems > 0)
              Text('${cart.totalItems} món', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
          ],
        ),
        centerTitle: true,
        actions: [
          if (cart.totalItems > 0)
            TextButton(
              onPressed: () => _confirmClear(context, cart),
              child: const Text('Xoá tất cả', style: TextStyle(color: AppColors.error, fontSize: 13)),
            ),
        ],
      ),
      body: cart.isEmpty ? _buildEmpty(context) : _buildCart(context, cart),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🛒', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 20),
          const Text(AppStrings.emptyCart,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 8),
          const Text(AppStrings.emptyCartSub,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
          const SizedBox(height: 28),
          CustomButton(
            text: 'Khám phá thực đơn',
            width: 200,
            icon: Icons.restaurant_menu_outlined,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.menu),
          ),
        ],
      ),
    );
  }

  Widget _buildCart(BuildContext context, CartProvider cart) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Items list
              ...cart.items.map((item) => Dismissible(
                    key: Key(item.foodItem.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                    ),
                    confirmDismiss: (_) async {
                      cart.removeItem(item.foodItem.id);
                      return false;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.foodItem.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 80,
                                color: AppColors.primary.withOpacity(0.1),
                                child: Icon(Icons.restaurant, color: AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Name + controls
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.foodItem.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                const SizedBox(height: 4),
                                Text(item.foodItem.formattedPrice,
                                    style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
                                if (item.note != null && item.note!.isNotEmpty)
                                  Text('📝 ${item.note}',
                                      style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _qtyBtn(Icons.remove, () => cart.decreaseQuantity(item.foodItem.id)),
                                    Container(
                                      width: 36,
                                      alignment: Alignment.center,
                                      child: Text('${item.quantity}',
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                    ),
                                    _qtyBtn(Icons.add, () => cart.increaseQuantity(item.foodItem.id)),
                                    const Spacer(),
                                    Text(item.formattedTotalPrice,
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 8),

              // Voucher
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_offer_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _voucherCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Nhập mã giảm giá (GIAM20, FREESHIP...)',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 13),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        cart.applyDiscount(_voucherCtrl.text);
                        setState(() => _voucherApplied = true);
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Áp dụng mã giảm giá thành công! 🎉'),
                          backgroundColor: AppColors.success,
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Áp dụng', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    _summaryRow('Tạm tính', _fmt(cart.subtotal)),
                    const SizedBox(height: 8),
                    _summaryRow('Phí giao hàng', _fmt(cart.deliveryFee), isDiscount: cart.deliveryFee == 0),
                    if (cart.discount > 0) ...[
                      const SizedBox(height: 8),
                      _summaryRow('Giảm giá', '-${_fmt(cart.discount)}', isDiscount: true),
                    ],
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng cộng',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                        Text(_fmt(cart.total),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),

        // Bottom checkout button
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -3))],
          ),
          child: CustomButton(
            text: 'Đặt hàng  •  ${_fmt(cart.total)}',
            icon: Icons.arrow_forward,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.checkout),
          ),
        ),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
      );

  Widget _summaryRow(String label, String value, {bool isDiscount = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textGrey)),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDiscount ? AppColors.success : AppColors.textDark)),
        ],
      );

  String _fmt(double v) => '${v.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  )}đ';

  void _confirmClear(BuildContext ctx, CartProvider cart) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Xoá giỏ hàng?'),
        content: const Text('Bạn có chắc muốn xoá tất cả món khỏi giỏ hàng?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Xoá', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
