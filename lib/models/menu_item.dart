class MenuItem {
  final String id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final int prepTimeMinutes;
  final bool isAvailable;
  final bool isSpicy;
  final String? badge;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.description,
    required this.prepTimeMinutes,
    this.isAvailable = true,
    this.isSpicy = false,
    this.badge,
  });
}
