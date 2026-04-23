import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    // Load orders từ Firestore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().currentUser?.id;
      if (userId != null) {
        context.read<CartProvider>().loadOrders(userId);
      }
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final activeOrders = cart.orders
        .where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled)
        .toList();
    final historyOrders = cart.orders
        .where((o) => o.status == OrderStatus.delivered || o.status == OrderStatus.cancelled)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
              )
            : null,
        title: const Text(AppStrings.myOrders,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabs,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: [
            Tab(text: 'Đang xử lý (${activeOrders.length})'),
            Tab(text: 'Lịch sử (${historyOrders.length})'),
          ],
        ),
      ),
      body: cart.isLoadingOrders
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabs,
        children: [
          _buildList(activeOrders),
          _buildList(historyOrders),
        ],
      ),
    );
  }

  Widget _buildList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📦', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text('Chưa có đơn hàng nào',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 8),
            const Text('Hãy đặt món ăn đầu tiên của bạn!',
                style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (_, i) => _buildOrderCard(orders[i]),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final statusColor = _statusColor(order.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Text('🧾 ${order.id.substring(order.id.length - 8)}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(order.status.label,
                      style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          // Items list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...order.items.take(3).map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Text('${item.quantity}×', style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item.foodItem.name, style: const TextStyle(fontSize: 13, color: AppColors.textDark))),
                          Text(item.formattedTotalPrice, style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
                        ],
                      ),
                    )),
                if (order.items.length > 3)
                  Text('... và ${order.items.length - 3} món khác',
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                const Divider(height: 20),

                // Timeline (for active orders)
                if (order.status != OrderStatus.delivered && order.status != OrderStatus.cancelled)
                  _buildTimeline(order.status),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${order.totalItems} món  •  ${order.paymentMethod.icon} ${order.paymentMethod.label}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                        const SizedBox(height: 2),
                        Text('${_formatDate(order.createdAt)}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                      ],
                    ),
                    const Spacer(),
                    Text(order.formattedTotal,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(OrderStatus currentStatus) {
    final steps = [
      {'status': OrderStatus.pending, 'icon': '⏳', 'label': 'Chờ x.nhận'},
      {'status': OrderStatus.confirmed, 'icon': '✅', 'label': 'Xác nhận'},
      {'status': OrderStatus.preparing, 'icon': '👨‍🍳', 'label': 'Chuẩn bị'},
      {'status': OrderStatus.delivering, 'icon': '🛵', 'label': 'Đang giao'},
    ];

    final currentIdx = OrderStatus.values.indexOf(currentStatus);

    return Row(
      children: steps.asMap().entries.map((entry) {
        final idx = entry.key;
        final step = entry.value;
        final stepStatus = step['status'] as OrderStatus;
        final stepIdx = OrderStatus.values.indexOf(stepStatus);
        final isDone = stepIdx <= currentIdx;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isDone ? AppColors.primary : AppColors.border,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(step['icon'] as String, style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(step['label'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: isDone ? AppColors.primary : AppColors.textLight,
                            fontWeight: isDone ? FontWeight.w600 : FontWeight.w400)),
                  ],
                ),
              ),
              if (idx < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: stepIdx < currentIdx ? AppColors.primary : AppColors.border,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending: return AppColors.statusPending;
      case OrderStatus.confirmed: return AppColors.statusConfirmed;
      case OrderStatus.preparing: return AppColors.statusPreparing;
      case OrderStatus.delivering: return AppColors.statusDelivering;
      case OrderStatus.delivered: return AppColors.statusDelivered;
      case OrderStatus.cancelled: return AppColors.statusCancelled;
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
