class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isPopular;
  final bool isAvailable;
  final List<String> tags;
  final int prepTimeMinutes;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.isPopular = false,
    this.isAvailable = true,
    this.tags = const [],
    this.prepTimeMinutes = 20,
  });

  String get formattedPrice {
    return '${price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}đ';
  }

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    bool? isPopular,
    bool? isAvailable,
    List<String>? tags,
    int? prepTimeMinutes,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isPopular: isPopular ?? this.isPopular,
      isAvailable: isAvailable ?? this.isAvailable,
      tags: tags ?? this.tags,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
    );
  }

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'isPopular': isPopular,
      'isAvailable': isAvailable,
      'tags': tags,
      'prepTimeMinutes': prepTimeMinutes,
    };
  }

  // Create from JSON
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: json['reviewCount'] as int? ?? 0,
      isPopular: json['isPopular'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      prepTimeMinutes: json['prepTimeMinutes'] as int? ?? 20,
    );
  }
}
