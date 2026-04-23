import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_item.dart';
import '../data/mock_data.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload all food items to Firebase
  Future<void> uploadFoodItems() async {
    try {
      final batch = _firestore.batch();
      
      for (var foodItem in MockData.foodItems) {
        final docRef = _firestore.collection('food_items').doc(foodItem.id);
        batch.set(docRef, foodItem.toJson());
      }
      
      await batch.commit();
      print('✅ Successfully uploaded ${MockData.foodItems.length} food items');
    } catch (e) {
      print('❌ Error uploading food items: $e');
      rethrow;
    }
  }

  // Upload categories
  Future<void> uploadCategories() async {
    try {
      final batch = _firestore.batch();
      
      for (int i = 0; i < MockData.categories.length; i++) {
        final docRef = _firestore.collection('categories').doc('cat_$i');
        batch.set(docRef, {
          'name': MockData.categories[i],
          'emoji': MockData.categoryEmojis[i],
          'order': i,
        });
      }
      
      await batch.commit();
      print('✅ Successfully uploaded ${MockData.categories.length} categories');
    } catch (e) {
      print('❌ Error uploading categories: $e');
      rethrow;
    }
  }

  // Upload banners
  Future<void> uploadBanners() async {
    try {
      final batch = _firestore.batch();
      
      for (int i = 0; i < MockData.banners.length; i++) {
        final docRef = _firestore.collection('banners').doc('banner_$i');
        batch.set(docRef, {
          ...MockData.banners[i],
          'order': i,
          'isActive': true,
        });
      }
      
      await batch.commit();
      print('✅ Successfully uploaded ${MockData.banners.length} banners');
    } catch (e) {
      print('❌ Error uploading banners: $e');
      rethrow;
    }
  }

  // Upload admin stats
  Future<void> uploadAdminStats() async {
    try {
      await _firestore.collection('admin_stats').doc('current').set({
        'todayRevenue': MockData.todayRevenue,
        'todayOrderCount': MockData.todayOrderCount,
        'totalUserCount': MockData.totalUserCount,
        'monthRevenue': MockData.monthRevenue,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      print('✅ Successfully uploaded admin stats');
    } catch (e) {
      print('❌ Error uploading admin stats: $e');
      rethrow;
    }
  }

  // Upload all data at once
  Future<void> uploadAllMockData() async {
    print('🚀 Starting to upload all mock data to Firebase...\n');
    
    await uploadCategories();
    await uploadBanners();
    await uploadFoodItems();
    await uploadAdminStats();
    
    print('\n✨ All mock data uploaded successfully!');
  }

  // Fetch food items from Firebase
  Future<List<FoodItem>> getFoodItems() async {
    try {
      final snapshot = await _firestore.collection('food_items').get();
      return snapshot.docs
          .map((doc) => FoodItem.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error fetching food items: $e');
      return [];
    }
  }

  // Fetch food items by category
  Future<List<FoodItem>> getFoodItemsByCategory(String category) async {
    try {
      if (category == 'Tất cả') {
        return getFoodItems();
      }
      
      final snapshot = await _firestore
          .collection('food_items')
          .where('category', isEqualTo: category)
          .get();
      
      return snapshot.docs
          .map((doc) => FoodItem.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error fetching food items by category: $e');
      return [];
    }
  }

  // Fetch popular items
  Future<List<FoodItem>> getPopularItems() async {
    try {
      final snapshot = await _firestore
          .collection('food_items')
          .where('isPopular', isEqualTo: true)
          .get();
      
      return snapshot.docs
          .map((doc) => FoodItem.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error fetching popular items: $e');
      return [];
    }
  }

  // Search food items
  Future<List<FoodItem>> searchFoodItems(String query) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // For production, consider using Algolia or similar service
      final snapshot = await _firestore.collection('food_items').get();
      final allItems = snapshot.docs
          .map((doc) => FoodItem.fromJson(doc.data()))
          .toList();
      
      final q = query.toLowerCase();
      return allItems.where((item) =>
          item.name.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          item.category.toLowerCase().contains(q)
      ).toList();
    } catch (e) {
      print('❌ Error searching food items: $e');
      return [];
    }
  }
}
