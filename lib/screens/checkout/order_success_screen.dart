import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../widgets/custom_button.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success animation container
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('✅', style: TextStyle(fontSize: 72)),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Đặt hàng thành công!',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                const SizedBox(height: 12),
                const Text(
                  'Đơn hàng của bạn đã được xác nhận.\nChúng tôi sẽ giao hàng trong 25–35 phút.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: AppColors.textGrey, height: 1.6),
                ),
                const SizedBox(height: 40),

                // Estimated time card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🛵', style: TextStyle(fontSize: 36)),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Đang giao hàng', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          Text('25 – 35 phút', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: 'Xem đơn hàng',
                  icon: Icons.receipt_long_outlined,
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.orders),
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Về trang chủ',
                  isOutlined: true,
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
