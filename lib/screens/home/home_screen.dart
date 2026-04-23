import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../data/mock_data.dart';
import '../../models/food_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/food_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  int _bottomNavIndex = 0;
  final PageController _bannerCtrl = PageController();
  int _bannerPage = 0;

  @override
  void initState() {
    super.initState();
    // Auto-scroll banner
    Future.delayed(const Duration(seconds: 3), _autoScrollBanner);
  }

  void _autoScrollBanner() {
    if (!mounted) return;
    final next = (_bannerPage + 1) % MockData.banners.length;
    _bannerCtrl.animateToPage(next,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    Future.delayed(const Duration(seconds: 3), _autoScrollBanner);
  }

  @override
  void dispose() {
    _bannerCtrl.dispose();
    super.dispose();
  }

  String _getTimeGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Chào buổi sáng ☀️';
    if (h < 18) return 'Chào buổi chiều 🌤';
    return 'Chào buổi tối 🌙';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();
    final category = MockData.categories[_selectedCategory];
    final foods = MockData.getByCategory(category);
    final popular = MockData.getPopularItems();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── App Bar ───────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getTimeGreeting(),
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            Text(
                              auth.currentUser?.fullName ?? 'Khách',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Cart icon
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                        child: Stack(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                            ),
                            if (cart.totalItems > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${cart.totalItems}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Profile avatar
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(Icons.person_outline, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.menu),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.textGrey),
                          const SizedBox(width: 10),
                          Text(AppStrings.search,
                              style: const TextStyle(color: AppColors.textLight, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Body ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // ── Banner Carousel ─────────────────
                  SizedBox(
                    height: 160,
                    child: PageView.builder(
                      controller: _bannerCtrl,
                      itemCount: MockData.banners.length,
                      onPageChanged: (i) => setState(() => _bannerPage = i),
                      itemBuilder: (_, i) {
                        final b = MockData.banners[i];
                        final color = Color(int.parse(b['color']!));
                        return _buildBanner(b['title']!, b['subtitle']!, b['code']!, color);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      MockData.banners.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _bannerPage ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _bannerPage ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Categories ──────────────────────
                  _sectionHeader('Danh mục', () => Navigator.pushNamed(context, AppRoutes.menu)),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 88,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: MockData.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => GestureDetector(
                        onTap: () => setState(() => _selectedCategory = i),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: i == _selectedCategory ? AppColors.primaryGradient : null,
                                color: i == _selectedCategory ? null : AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: i == _selectedCategory
                                        ? AppColors.primary.withOpacity(0.3)
                                        : Colors.black.withOpacity(0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  MockData.categoryEmojis[i],
                                  style: const TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              MockData.categories[i],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: i == _selectedCategory ? FontWeight.w600 : FontWeight.w400,
                                color: i == _selectedCategory ? AppColors.primary : AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Popular ─────────────────────────
                  _sectionHeader(AppStrings.popular, () {}),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 240,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: popular.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (_, i) => FoodCard(
                        food: popular[i],
                        onAddToCart: () {
                          context.read<CartProvider>().addItem(popular[i]);
                          _showAddedSnack(context, popular[i]);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Menu by Category ────────────────
                  _sectionHeader(
                    MockData.categories[_selectedCategory] == 'Tất cả'
                        ? 'Tất cả món ăn'
                        : MockData.categories[_selectedCategory],
                    () => Navigator.pushNamed(context, AppRoutes.menu),
                  ),
                  const SizedBox(height: 14),
                  ...foods.map(
                    (food) => FoodCard(
                      food: food,
                      horizontal: true,
                      onAddToCart: () {
                        context.read<CartProvider>().addItem(food);
                        _showAddedSnack(context, food);
                      },
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBanner(String title, String subtitle, String code, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Mã: $code',
                      style: const TextStyle(color: Colors.white, fontSize: 11)),
                ),
                const SizedBox(height: 8),
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
              ],
            ),
          ),
          const Text('🎉', style: TextStyle(fontSize: 60)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        GestureDetector(
          onTap: onViewAll,
          child: const Text(AppStrings.viewAll,
              style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -3))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_rounded, Icons.home_outlined, 'Trang chủ', () {}),
              _navItem(1, Icons.restaurant_menu_rounded, Icons.restaurant_menu_outlined, 'Thực đơn',
                  () => Navigator.pushNamed(context, AppRoutes.menu)),
              _navItem(2, Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Đơn hàng',
                  () => Navigator.pushNamed(context, AppRoutes.orders)),
              _navItem(3, Icons.person_rounded, Icons.person_outlined, 'Hồ sơ',
                  () => Navigator.pushNamed(context, AppRoutes.profile)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData active, IconData inactive, String label, VoidCallback onTap) {
    final isSelected = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _bottomNavIndex = index);
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? active : inactive,
                color: isSelected ? AppColors.primary : AppColors.textLight, size: 24),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? AppColors.primary : AppColors.textLight,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  void _showAddedSnack(BuildContext ctx, FoodItem food) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('Đã thêm ${food.name} vào giỏ hàng 🛒'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
