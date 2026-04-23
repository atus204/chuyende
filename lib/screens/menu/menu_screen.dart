import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/mock_data.dart';
import '../../models/food_item.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/food_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';
  String _sortBy = 'Mặc định';

  List<FoodItem> get _filteredFoods {
    List<FoodItem> foods = _searchQuery.isNotEmpty
        ? MockData.search(_searchQuery)
        : MockData.getByCategory(_selectedCategory);

    switch (_sortBy) {
      case 'Giá tăng dần':
        foods = [...foods]..sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Giá giảm dần':
        foods = [...foods]..sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Đánh giá cao':
        foods = [...foods]..sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Phổ biến':
        foods = [...foods]..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }
    return foods;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foods = _filteredFoods;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (Navigator.canPop(context))
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textDark),
                        ),
                      if (Navigator.canPop(context)) const SizedBox(width: 12),
                      const Text(AppStrings.menu,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      const Spacer(),
                      // Sort button
                      GestureDetector(
                        onTap: _showSortSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.sort, size: 18, color: AppColors.textDark),
                              const SizedBox(width: 4),
                              Text('Sắp xếp',
                                  style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: AppStrings.search,
                      prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close, color: AppColors.textGrey),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),

            // Category tabs
            Container(
              color: AppColors.white,
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: MockData.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = MockData.categories[i];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedCategory = cat;
                      _searchQuery = '';
                      _searchCtrl.clear();
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected ? null : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(MockData.categoryEmojis[i], style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            cat,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Colors.white : AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Result count
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  Text(
                    '${foods.length} món',
                    style: const TextStyle(fontSize: 13, color: AppColors.textGrey, fontWeight: FontWeight.w500),
                  ),
                  if (_sortBy != 'Mặc định')
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(_sortBy,
                          style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                    ),
                ],
              ),
            ),

            // Food list
            Expanded(
              child: foods.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      itemCount: foods.length,
                      itemBuilder: (_, i) => FoodCard(
                        food: foods[i],
                        horizontal: true,
                        onAddToCart: () {
                          context.read<CartProvider>().addItem(foods[i]);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Đã thêm ${foods[i].name} vào giỏ 🛒'),
                            backgroundColor: AppColors.success,
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ));
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(AppStrings.noResults,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 8),
          Text('Thử tìm kiếm với từ khóa khác',
              style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
        ],
      ),
    );
  }

  void _showSortSheet() {
    final options = ['Mặc định', 'Giá tăng dần', 'Giá giảm dần', 'Đánh giá cao', 'Phổ biến'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('Sắp xếp theo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...options.map(
              (o) => ListTile(
                title: Text(o, style: const TextStyle(fontSize: 14)),
                trailing: _sortBy == o ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                onTap: () {
                  setState(() => _sortBy = o);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
