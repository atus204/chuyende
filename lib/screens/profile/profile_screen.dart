import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (Navigator.canPop(context))
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        ),
                      const Spacer(),
                      if (user != null)
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('Chỉnh sửa', style: TextStyle(color: Colors.white, fontSize: 13)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Center(
                      child: Text('👤', style: TextStyle(fontSize: 48)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user?.fullName ?? 'Chưa đăng nhập',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  if (user != null) ...[
                    const SizedBox(height: 4),
                    Text(user.email, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
                    if (user.isAdmin) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('⚙️ Quản trị viên',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.dark)),
                      ),
                    ],
                  ],
                  const SizedBox(height: 20),

                  // Stats
                  Row(
                    children: [
                      _stat('${cart.orders.length}', 'Đơn hàng'),
                      _divider(),
                      _stat('${cart.orders.where((o) => o.status.index >= 4).length}', 'Đã giao'),
                      _divider(),
                      _stat('0', 'Điểm thưởng'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Menu items
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (user?.isAdmin == true) ...[
                    _menuSection('Quản trị', [
                      _MenuItem('⚙️', 'Bảng quản trị', 'Quản lý toàn bộ hệ thống',
                          () => Navigator.pushNamed(context, AppRoutes.admin)),
                    ]),
                    const SizedBox(height: 16),
                  ],

                  _menuSection('Tài khoản', [
                    _MenuItem('📋', 'Đơn hàng của tôi', 'Xem lịch sử đặt món',
                        () => Navigator.pushNamed(context, AppRoutes.orders)),
                    _MenuItem('📍', 'Địa chỉ giao hàng', 'Quản lý địa chỉ của bạn', () {}),
                    _MenuItem('🔔', 'Thông báo', 'Cài đặt thông báo', () {}),
                    _MenuItem('🔒', 'Bảo mật', 'Đổi mật khẩu', () {}),
                  ]),
                  const SizedBox(height: 16),

                  _menuSection('Hỗ trợ', [
                    _MenuItem('❓', 'Trung tâm hỗ trợ', 'FAQ & liên hệ', () {}),
                    _MenuItem('⭐', 'Đánh giá ứng dụng', 'Chia sẻ trải nghiệm', () {}),
                    _MenuItem('ℹ️', 'Về chúng tôi', AppStrings.version, () {}),
                  ]),
                  const SizedBox(height: 24),

                  if (user != null)
                    CustomButton(
                      text: AppStrings.logout,
                      icon: Icons.logout,
                      backgroundColor: AppColors.error,
                      onPressed: () {
                        auth.logout();
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      },
                    )
                  else
                    CustomButton(
                      text: AppStrings.login,
                      icon: Icons.login,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) => Expanded(
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
          ],
        ),
      );

  Widget _divider() => Container(width: 1, height: 36, color: Colors.white.withOpacity(0.3));

  Widget _menuSection(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textGrey)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final item = entry.value;
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  GestureDetector(
                    onTap: item.onTap,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Text(item.emoji, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                                Text(item.subtitle,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.textLight),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast) const Divider(height: 1, indent: 52),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final String emoji;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem(this.emoji, this.title, this.subtitle, this.onTap);
}
