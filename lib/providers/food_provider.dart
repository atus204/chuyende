import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_item.dart';
import '../data/mock_data.dart';

class FoodProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<FoodItem> _allFoods = [];
  List<Map<String, dynamic>> _banners = [];
  bool _isLoading = false;
  String? _error;

  List<FoodItem> get allFoods => _allFoods;
  List<Map<String, dynamic>> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<String> get categories => MockData.categories;
  List<String> get categoryEmojis => MockData.categoryEmojis;

  List<FoodItem> getByCategory(String category) {
    if (category == 'Tất cả') return _allFoods;
    return _allFoods.where((f) => f.category == category).toList();
  }

  List<FoodItem> getPopular() => _allFoods.where((f) => f.isPopular).toList();

  List<FoodItem> search(String query) {
    final q = query.toLowerCase();
    return _allFoods
        .where((f) =>
            f.name.toLowerCase().contains(q) ||
            f.description.toLowerCase().contains(q) ||
            f.category.toLowerCase().contains(q))
        .toList();
  }

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _db.collection('food_items').get(),
        _db.collection('banners').orderBy('order').get(),
      ]);

      final foodSnap = results[0] as QuerySnapshot;
      final bannerSnap = results[1] as QuerySnapshot;

      _allFoods = foodSnap.docs
          .map((d) => FoodItem.fromJson(d.data() as Map<String, dynamic>))
          .toList();

      _banners = bannerSnap.docs
          .map((d) => d.data() as Map<String, dynamic>)
          .toList();

      // Fallback nếu Firestore chưa có dữ liệu
      if (_allFoods.isEmpty) _allFoods = MockData.foodItems.toList();
      if (_banners.isEmpty) _banners = MockData.banners.cast<Map<String, dynamic>>();
    } catch (e) {
      _error = e.toString();
      // Fallback về mock data khi lỗi
      _allFoods = MockData.foodItems.toList();
      _banners = MockData.banners.cast<Map<String, dynamic>>();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Upload mock data lên Firestore (chỉ dùng 1 lần)
  Future<void> seedFirestore() async {
    final batch = _db.batch();
    for (final item in MockData.foodItems) {
      batch.set(_db.collection('food_items').doc(item.id), item.toJson());
    }
    for (int i = 0; i < MockData.categories.length; i++) {
      batch.set(_db.collection('categories').doc('cat_$i'), {
        'name': MockData.categories[i],
        'emoji': MockData.categoryEmojis[i],
        'order': i,
      });
    }
    for (int i = 0; i < MockData.banners.length; i++) {
      batch.set(_db.collection('banners').doc('banner_$i'), {
        ...MockData.banners[i],
        'order': i,
        'isActive': true,
      });
    }
    await batch.commit();
    await loadData();
  }
}
