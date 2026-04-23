import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../data/mock_data.dart';
import '../../models/food_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/order_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/admin_upload_button.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();

    // Guard: only admin
    if (auth.currentUser?.isAdmin != true) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🚫', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text('Không có quyền truy cập', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              CustomButton(text: 'Quay lại', isSmall: true, width: 140, onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.darkGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bảng Quản Trị', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                          Text('Nhà Bếp Việt', style: TextStyle(color: Colors.white54, fontSize: 13)),
                        ],
                      ),
                      const Spacer(),
                      const Text('⚙️', style: TextStyle(fontSize: 28)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats cards
                  Row(
                    children: [
                      _statCard('💰', _fmtRevenue(MockData.todayRevenue), 'Doanh thu hôm nay', 0xFF4CAF50),
                      const SizedBox(width: 10),
                      _statCard('📦', '${cart.orders.isNotEmpty ? cart.orders.length : MockData.todayOrderCount}', 'Đơn hàng', 0xFF2196F3),
                      const SizedBox(width: 10),
                      _statCard('👥', '${MockData.totalUserCount}', 'Người dùng', 0xFFFF6B35),
                    ],
                  ),
                ],
              ),
            ),

            // Tab bar
            Container(
              color: AppColors.white,
              child: Row(
                children: [
                  _tabItem(0, '🍽 Thực đơn'),
                  _tabItem(1, '📦 Đơn hàng'),
                  _tabItem(2, '👥 Khách hàng'),
                ],
              ),
            ),

            // Content
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  _FoodManagementTab(),
                  _OrderManagementTab(orders: cart.orders, onStatusChange: (id, s) => cart.updateOrderStatus(id, s)),
                  _UserManagementTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String emoji, String value, String label, int colorHex) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(int idx, String label) {
    final isSelected = _selectedTab == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }

  String _fmtRevenue(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    return '${v.toStringAsFixed(0)}đ';
  }
}

// ── Food Management Tab ────────────────────────────────────
class _FoodManagementTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: [
              // Firebase Upload Button
              const AdminUploadButton(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('${MockData.foodItems.length} món', style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(10)),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text('Thêm món', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: MockData.foodItems.length,
            itemBuilder: (_, i) {
              final food = MockData.foodItems[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(food.imageUrl, width: 64, height: 64, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: AppColors.background,
                              child: const Icon(Icons.restaurant, color: AppColors.primary))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(food.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                          Text(food.category, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                          Text(food.formattedPrice, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: AppColors.textGrey),
                      onSelected: (v) {},
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                        const PopupMenuItem(value: 'toggle', child: Text('Ẩn/Hiện')),
                        const PopupMenuItem(value: 'delete', child: Text('Xoá', style: TextStyle(color: AppColors.error))),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Order Management Tab ───────────────────────────────────
class _OrderManagementTab extends StatelessWidget {
  final List<OrderModel> orders;
  final Function(String, OrderStatus) onStatusChange;

  const _OrderManagementTab({required this.orders, required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('📦', style: TextStyle(fontSize: 56)),
            SizedBox(height: 16),
            Text('Chưa có đơn hàng', style: TextStyle(fontSize: 16, color: AppColors.textGrey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, i) {
        final order = orders[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('#${order.id.substring(order.id.length - 6)}',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const Spacer(),
                  Text(order.status.label, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              Text('${order.totalItems} món  •  Địa chỉ: ${order.address}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(order.formattedTotal, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  const Spacer(),
                  DropdownButton<OrderStatus>(
                    value: order.status,
                    isDense: true,
                    underline: const SizedBox(),
                    items: OrderStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label, style: const TextStyle(fontSize: 12)))).toList(),
                    onChanged: (s) { if (s != null) onStatusChange(order.id, s); },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── User Management Tab ────────────────────────────────────
class _UserManagementTab extends StatelessWidget {
  final _mockUsers = const [
    {'name': 'Nguyễn Văn An', 'email': 'an@gmail.com', 'orders': 12, 'emoji': '👨'},
    {'name': 'Trần Thị Bình', 'email': 'binh@gmail.com', 'orders': 7, 'emoji': '👩'},
    {'name': 'Lê Quang Minh', 'email': 'minh@gmail.com', 'orders': 3, 'emoji': '👦'},
    {'name': 'Phạm Thu Hà', 'email': 'ha@gmail.com', 'orders': 19, 'emoji': '👧'},
    {'name': 'Hoàng Đức Mạnh', 'email': 'manh@gmail.com', 'orders': 5, 'emoji': '👨'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockUsers.length,
      itemBuilder: (_, i) {
        final u = _mockUsers[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), shape: BoxShape.circle),
                child: Center(child: Text(u['emoji'] as String, style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    Text(u['email'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  ],
                ),
              ),
              Column(
                children: [
                  Text('${u['orders']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  const Text('đơn', style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
