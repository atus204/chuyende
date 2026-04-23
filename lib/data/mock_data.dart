import '../models/food_item.dart';

class MockData {
  static const List<String> categories = [
    'Tất cả',
    'Cơm',
    'Phở & Bún',
    'Bánh',
    'Gà',
    'Hải sản',
    'Chay',
    'Tráng miệng',
    'Đồ uống',
  ];

  static const List<String> categoryEmojis = [
    '🍽',
    '🍚',
    '🍜',
    '🥐',
    '🍗',
    '🦐',
    '🥗',
    '🍮',
    '🧃',
  ];

  static const List<Map<String, String>> banners = [
    {
      'title': 'Giảm 20% hôm nay',
      'subtitle': 'Cho tất cả đơn hàng trên 150.000đ',
      'code': 'GIAM20',
      'color': '0xFFFF6B35',
    },
    {
      'title': 'Miễn phí giao hàng',
      'subtitle': 'Áp dụng cả ngày cuối tuần',
      'code': 'FREESHIP',
      'color': '0xFF1A1A2E',
    },
    {
      'title': 'Combo gia đình',
      'subtitle': 'Tiết kiệm đến 50.000đ cho nhóm 4+',
      'code': 'COMBO4',
      'color': '0xFFFFD166',
    },
  ];

  static const List<FoodItem> foodItems = [
    // === CƠM ===
    FoodItem(
      id: 'c1',
      name: 'Cơm Tấm Sườn Bì',
      description:
          'Cơm tấm thơm mềm, được ăn kèm với sườn nướng đậm đà, bì trộn giòn ngon và chả trứng hấp dẫn. Nước mắm chua ngọt pha theo công thức gia truyền.',
      price: 55000,
      imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=500',
      category: 'Cơm',
      rating: 4.8,
      reviewCount: 312,
      isPopular: true,
      tags: ['Đặc biệt', 'Bestseller'],
      prepTimeMinutes: 15,
    ),
    FoodItem(
      id: 'c2',
      name: 'Cơm Gà Hội An',
      description:
          'Cơm gà vàng om nước gà, thịt gà xé mềm thơm, rau răm và hành phi. Đặc trưng hương vị phố Hội.',
      price: 60000,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500',
      category: 'Cơm',
      rating: 4.6,
      reviewCount: 198,
      isPopular: true,
      tags: ['Đặc sản Hội An'],
      prepTimeMinutes: 12,
    ),
    FoodItem(
      id: 'c3',
      name: 'Cơm Chiên Dương Châu',
      description:
          'Cơm chiên với tôm, thịt xá xíu, trứng, đậu Hà Lan và rau củ. Hương thơm của cơm chiên đúng điệu.',
      price: 65000,
      imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=500',
      category: 'Cơm',
      rating: 4.4,
      reviewCount: 145,
      isPopular: false,
      tags: ['Cơm chiên'],
      prepTimeMinutes: 10,
    ),

    // === PHỞ & BÚN ===
    FoodItem(
      id: 'p1',
      name: 'Phở Bò Đặc Biệt',
      description:
          'Phở bò nước dùng trong vắt, hầm xương 12 tiếng với nhiều gia vị. Thịt bò tươi, bánh phở mềm dai, rau thơm xanh mướt.',
      price: 75000,
      imageUrl: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=500',
      category: 'Phở & Bún',
      rating: 4.9,
      reviewCount: 521,
      isPopular: true,
      tags: ['Đặc biệt', 'Yêu thích nhất'],
      prepTimeMinutes: 8,
    ),
    FoodItem(
      id: 'p2',
      name: 'Bún Bò Huế',
      description:
          'Bún bò Huế cay nồng đặc trưng, nước dùng đậm đà từ xương bò và mắm ruốc. Có chả cua, bắp bò và giò heo.',
      price: 70000,
      imageUrl: 'https://images.unsplash.com/photo-1609501676725-7186f017a4ba?w=500',
      category: 'Phở & Bún',
      rating: 4.7,
      reviewCount: 287,
      isPopular: true,
      tags: ['Cay', 'Đặc sản Huế'],
      prepTimeMinutes: 10,
    ),
    FoodItem(
      id: 'p3',
      name: 'Bún Chả Hà Nội',
      description:
          'Bún chả theo phong cách Hà Nội với chả viên và chả miếng nướng thơm. Nước chấm chua ngọt, ăn kèm rau sống và nem rán.',
      price: 65000,
      imageUrl: 'https://images.unsplash.com/photo-1555126634-323283e090fa?w=500',
      category: 'Phở & Bún',
      rating: 4.6,
      reviewCount: 203,
      isPopular: false,
      tags: ['Đặc sản HN'],
      prepTimeMinutes: 12,
    ),
    FoodItem(
      id: 'p4',
      name: 'Mì Quảng Đà Nẵng',
      description:
          'Mì Quảng vàng óng với tôm, thịt heo, đậu phộng rang và bánh tráng giòn. Nước dùng đặc sệt thấm vị.',
      price: 60000,
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500',
      category: 'Phở & Bún',
      rating: 4.5,
      reviewCount: 167,
      isPopular: false,
      tags: ['Đặc sản ĐN'],
      prepTimeMinutes: 10,
    ),

    // === BÁNH ===
    FoodItem(
      id: 'b1',
      name: 'Bánh Mì Thịt Nướng',
      description:
          'Bánh mì giòn rụm, nhân thịt nướng thơm phức, pate béo ngậy, dưa leo tươi mát, rau mùi và tương ớt cay.',
      price: 35000,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
      category: 'Bánh',
      rating: 4.8,
      reviewCount: 445,
      isPopular: true,
      tags: ['Nhanh', 'Tiện lợi'],
      prepTimeMinutes: 5,
    ),
    FoodItem(
      id: 'b2',
      name: 'Bánh Xèo Giòn',
      description:
          'Bánh xèo vàng giòn nhân tôm, thịt, giá đỗ và hành. Ăn kèm rau sống và nước chấm chua ngọt.',
      price: 45000,
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=500',
      category: 'Bánh',
      rating: 4.5,
      reviewCount: 189,
      isPopular: false,
      tags: ['Giòn', 'Truyền thống'],
      prepTimeMinutes: 15,
    ),

    // === GÀ ===
    FoodItem(
      id: 'g1',
      name: 'Gà Rán Giòn Cay',
      description:
          'Gà rán giòn rụm với lớp vỏ crispy đặc biệt, bên trong thịt mềm ngọt. Ướp gia vị cay nồng đặc trưng.',
      price: 80000,
      imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?w=500',
      category: 'Gà',
      rating: 4.7,
      reviewCount: 356,
      isPopular: true,
      tags: ['Cay', 'Giòn', 'Bestseller'],
      prepTimeMinutes: 20,
    ),
    FoodItem(
      id: 'g2',
      name: 'Cánh Gà Nướng Mật Ong',
      description:
          'Cánh gà nướng với mật ong và tỏi, da giòn vàng ươm, thịt mọng nước ngọt ngào. Phục vụ kèm salad xanh.',
      price: 75000,
      imageUrl: 'https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=500',
      category: 'Gà',
      rating: 4.6,
      reviewCount: 234,
      isPopular: false,
      tags: ['Nướng', 'Ngọt'],
      prepTimeMinutes: 25,
    ),

    // === HẢI SẢN ===
    FoodItem(
      id: 'h1',
      name: 'Tôm Hùm Nướng Phô Mai',
      description:
          'Tôm hùm tươi nướng với phô mai vàng tan chảy, bơ tỏi thơm lừng. Món hải sản cao cấp đặc biệt.',
      price: 250000,
      imageUrl: 'https://images.unsplash.com/photo-1565680018460-a57c4f4c5a46?w=500',
      category: 'Hải sản',
      rating: 4.9,
      reviewCount: 98,
      isPopular: false,
      tags: ['Cao cấp', 'Đặc biệt'],
      prepTimeMinutes: 30,
    ),
    FoodItem(
      id: 'h2',
      name: 'Nghêu Hấp Sả',
      description:
          'Nghêu tươi hấp sả và gừng, vỏ mở đều, thịt ngọt mềm. Nước hấp thơm ngát vị sả.',
      price: 85000,
      imageUrl: 'https://images.unsplash.com/photo-1559737558-2f5a35f4523b?w=500',
      category: 'Hải sản',
      rating: 4.5,
      reviewCount: 156,
      isPopular: true,
      tags: ['Tươi sống', 'Hải sản'],
      prepTimeMinutes: 15,
    ),

    // === TRÁNG MIỆNG ===
    FoodItem(
      id: 't1',
      name: 'Chè Thái Đặc Biệt',
      description:
          'Chè thái với nước cốt dừa béo ngậy, thạch màu sắc, trái cây nhiệt đới tươi và đá bào mát lạnh.',
      price: 40000,
      imageUrl: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=500',
      category: 'Tráng miệng',
      rating: 4.6,
      reviewCount: 267,
      isPopular: true,
      tags: ['Ngọt', 'Mát', 'Truyền thống'],
      prepTimeMinutes: 5,
    ),
    FoodItem(
      id: 't2',
      name: 'Bánh Flan Caramel',
      description:
          'Bánh flan mềm mịn với lớp caramel thơm vị cà phê. Lạnh mát, ngọt vừa phải, tan trong miệng.',
      price: 30000,
      imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500',
      category: 'Tráng miệng',
      rating: 4.4,
      reviewCount: 178,
      isPopular: false,
      tags: ['Ngọt', 'Mát'],
      prepTimeMinutes: 3,
    ),

    // === ĐỒ UỐNG ===
    FoodItem(
      id: 'd1',
      name: 'Cà Phê Sữa Đá',
      description:
          'Cà phê phin truyền thống pha với sữa đặc và đá, đậm vị cà phê thơm. Uống kèm rất hợp với bất kỳ món ăn nào.',
      price: 30000,
      imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500',
      category: 'Đồ uống',
      rating: 4.7,
      reviewCount: 398,
      isPopular: true,
      tags: ['Cà phê', 'Mát lạnh'],
      prepTimeMinutes: 5,
    ),
    FoodItem(
      id: 'd2',
      name: 'Nước Mía Tươi',
      description:
          'Nước mía ép tươi ngon, ngọt thanh, pha chút chanh và gừng. Giải nhiệt tốt, bổ dưỡng tự nhiên.',
      price: 25000,
      imageUrl: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=500',
      category: 'Đồ uống',
      rating: 4.5,
      reviewCount: 213,
      isPopular: false,
      tags: ['Mát', 'Tươi'],
      prepTimeMinutes: 3,
    ),
  ];

  static List<FoodItem> getPopularItems() =>
      foodItems.where((f) => f.isPopular).toList();

  static List<FoodItem> getByCategory(String category) {
    if (category == 'Tất cả') return foodItems;
    return foodItems.where((f) => f.category == category).toList();
  }

  static List<FoodItem> search(String query) {
    final q = query.toLowerCase();
    return foodItems
        .where((f) =>
            f.name.toLowerCase().contains(q) ||
            f.description.toLowerCase().contains(q) ||
            f.category.toLowerCase().contains(q))
        .toList();
  }

  // Admin mock stats
  static const double todayRevenue = 3450000;
  static const int todayOrderCount = 28;
  static const int totalUserCount = 156;
  static const double monthRevenue = 87500000;
}
