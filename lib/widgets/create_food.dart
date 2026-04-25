import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';
import '../models/food_item.dart';
import '../providers/food_provider.dart';

/// Shows the Create Food bottom sheet.
Future<void> showCreateFoodSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CreateFoodSheet(),
  );
}

class _CreateFoodSheet extends StatefulWidget {
  const _CreateFoodSheet();

  @override
  State<_CreateFoodSheet> createState() => _CreateFoodSheetState();
}

class _CreateFoodSheetState extends State<_CreateFoodSheet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _prepCtrl = TextEditingController(text: '15');
  final _tagsCtrl = TextEditingController();

  String _selectedCategory = MockData.categories[1]; // default: Cơm
  bool _isPopular = false;
  bool _isAvailable = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _imageCtrl.dispose();
    _prepCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final tags = _tagsCtrl.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final newFood = FoodItem(
      id: 'food_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      imageUrl: _imageCtrl.text.trim(),
      category: _selectedCategory,
      isPopular: _isPopular,
      isAvailable: _isAvailable,
      tags: tags,
      prepTimeMinutes: int.tryParse(_prepCtrl.text.trim()) ?? 15,
    );

    try {
      await context.read<FoodProvider>().addFood(newFood);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Đã thêm "${newFood.name}" thành công!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Lỗi: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thêm món mới',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Nhà Bếp Việt',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.close, size: 18, color: AppColors.textGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form — scrollable
          Flexible(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      controller: _nameCtrl,
                      label: 'Tên món *',
                      hint: 'VD: Phở Bò Đặc Biệt',
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên món' : null,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _descCtrl,
                      label: 'Mô tả *',
                      hint: 'Mô tả ngắn về món ăn...',
                      maxLines: 3,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Vui lòng nhập mô tả' : null,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            controller: _priceCtrl,
                            label: 'Giá (đ) *',
                            hint: '55000',
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Nhập giá';
                              final n = double.tryParse(v.trim());
                              if (n == null || n <= 0) return 'Giá không hợp lệ';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            controller: _prepCtrl,
                            label: 'Thời gian (phút)',
                            hint: '15',
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      controller: _imageCtrl,
                      label: 'URL ảnh *',
                      hint: 'https://images.unsplash.com/...',
                      keyboardType: TextInputType.url,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Vui lòng nhập URL ảnh' : null,
                    ),
                    const SizedBox(height: 14),

                    // Category dropdown
                    _buildLabel('Danh mục *'),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textGrey),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textDark,
                            fontFamily: 'Poppins',
                          ),
                          items: MockData.categories
                              .where((c) => c != 'Tất cả')
                              .map((c) {
                            final idx = MockData.categories.indexOf(c);
                            final emoji = idx < MockData.categoryEmojis.length
                                ? MockData.categoryEmojis[idx]
                                : '🍽';
                            return DropdownMenuItem(
                              value: c,
                              child: Text('$emoji  $c'),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedCategory = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildField(
                      controller: _tagsCtrl,
                      label: 'Tags (phân cách bằng dấu phẩy)',
                      hint: 'VD: Đặc biệt, Bestseller, Cay',
                    ),
                    const SizedBox(height: 16),

                    // Toggles
                    _buildToggleRow(
                      emoji: '🔥',
                      label: 'Món phổ biến',
                      subtitle: 'Hiển thị trong mục "Phổ biến"',
                      value: _isPopular,
                      onChanged: (v) => setState(() => _isPopular = v),
                    ),
                    const SizedBox(height: 10),
                    _buildToggleRow(
                      emoji: '✅',
                      label: 'Đang bán',
                      subtitle: 'Khách hàng có thể đặt món này',
                      value: _isAvailable,
                      onChanged: (v) => setState(() => _isAvailable = v),
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Thêm món',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.textLight),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required String emoji,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primaryLight,
          ),
        ],
      ),
    );
  }
}
