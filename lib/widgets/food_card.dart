import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/food_item.dart';
import '../core/constants/app_routes.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback? onAddToCart;
  final bool horizontal;

  const FoodCard({
    super.key,
    required this.food,
    this.onAddToCart,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return horizontal ? _buildHorizontal(context) : _buildVertical(context);
  }

  Widget _buildVertical(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.foodDetail, arguments: food),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    food.imageUrl,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 130,
                      color: AppColors.primary.withOpacity(0.15),
                      child: Icon(Icons.restaurant, color: AppColors.primary, size: 48),
                    ),
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : Container(
                            height: 130,
                            color: AppColors.background,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                  ),
                ),
                // Popular badge
                if (food.isPopular)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '🔥 Phổ biến',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.dark,
                        ),
                      ),
                    ),
                  ),
                // Availability overlay
                if (!food.isAvailable)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Text(
                            'Hết hàng',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.accent, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          food.rating.toString(),
                          style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${food.reviewCount})',
                          style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          food.formattedPrice,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: food.isAvailable ? onAddToCart : null,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: food.isAvailable ? AppColors.primary : AppColors.textLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.foodDetail, arguments: food),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Image.network(
                food.imageUrl,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 110,
                  color: AppColors.primary.withOpacity(0.12),
                  child: Icon(Icons.restaurant, color: AppColors.primary, size: 36),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (food.isPopular)
                      Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '🔥 Phổ biến',
                          style: TextStyle(fontSize: 10, color: AppColors.accentDark, fontWeight: FontWeight.w600),
                        ),
                      ),
                    Text(
                      food.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.accent, size: 14),
                        Text(' ${food.rating}', style: const TextStyle(fontSize: 12, color: AppColors.textMedium, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 8),
                        Icon(Icons.access_time_rounded, size: 12, color: AppColors.textGrey),
                        Text(' ${food.prepTimeMinutes}p', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                        const Spacer(),
                        Text(
                          food.formattedPrice,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: food.isAvailable ? onAddToCart : null,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              gradient: food.isAvailable ? AppColors.primaryGradient : null,
                              color: food.isAvailable ? null : AppColors.textLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
