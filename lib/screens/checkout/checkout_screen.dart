import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  PaymentMethod _selectedPayment = PaymentMethod.cash;
  bool _isPlacing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null && user.address.isNotEmpty) {
        _addressCtrl.text = user.address;
      }
    });
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ giao hàng'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isPlacing = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    final cart = context.read<CartProvider>();
    cart.placeOrder(
      address: _addressCtrl.text.trim(),
      paymentMethod: _selectedPayment,
      note: _noteCtrl.text,
    );
    setState(() => _isPlacing = false);

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.orderSuccess,
      (route) => route.settings.name == AppRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
        ),
        title: const Text('Xác nhận đơn hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Estimated time ──────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Text('🛵', style: TextStyle(fontSize: 32)),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Thời gian giao hàng dự kiến',
                                style: TextStyle(color: Colors.white70, fontSize: 13)),
                            Text('25 – 35 phút',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Delivery Address ─────────────────
                  _sectionTitle('📍 Địa chỉ giao hàng'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _addressCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Nhập địa chỉ giao hàng chi tiết...',
                      prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Payment Method ───────────────────
                  _sectionTitle('💳 Phương thức thanh toán'),
                  const SizedBox(height: 10),
                  ...PaymentMethod.values.map((method) => GestureDetector(
                        onTap: () => setState(() => _selectedPayment = method),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _selectedPayment == method ? AppColors.primary : AppColors.border,
                              width: _selectedPayment == method ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(method.icon, style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 14),
                              Text(method.label,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: _selectedPayment == method ? FontWeight.w600 : FontWeight.w400,
                                      color: AppColors.textDark)),
                              const Spacer(),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: _selectedPayment == method ? AppColors.primary : AppColors.border, width: 2),
                                  color: _selectedPayment == method ? AppColors.primary : Colors.transparent,
                                ),
                                child: _selectedPayment == method
                                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      )),

                  const SizedBox(height: 20),

                  // ── Note ────────────────────────────
                  _sectionTitle('📝 Ghi chú đơn hàng'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _noteCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(hintText: 'Giao vào buổi sáng, gọi trước 15 phút...'),
                  ),
                  const SizedBox(height: 20),

                  // ── Order Summary ────────────────────
                  _sectionTitle('🧾 Tóm tắt đơn hàng'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        ...cart.items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Text('${item.quantity}',
                                          style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(item.foodItem.name,
                                        style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
                                  ),
                                  Text(item.formattedTotalPrice,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                ],
                              ),
                            )),
                        const Divider(),
                        _summaryRow('Tạm tính', _fmt(cart.subtotal)),
                        const SizedBox(height: 6),
                        _summaryRow('Phí giao hàng', _fmt(cart.deliveryFee)),
                        if (cart.discount > 0) ...[
                          const SizedBox(height: 6),
                          _summaryRow('Giảm giá', '-${_fmt(cart.discount)}', isDiscount: true),
                        ],
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tổng cộng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            Text(_fmt(cart.total),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Place order button
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.white,
              boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, -3))],
            ),
            child: CustomButton(
              text: 'Xác nhận đặt hàng  •  ${_fmt(cart.total)}',
              icon: Icons.check_circle_outline,
              isLoading: _isPlacing,
              onPressed: _placeOrder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark));

  Widget _summaryRow(String label, String value, {bool isDiscount = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
          Text(value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDiscount ? AppColors.success : AppColors.textDark)),
        ],
      );

  String _fmt(double v) => '${v.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  )}đ';
}
