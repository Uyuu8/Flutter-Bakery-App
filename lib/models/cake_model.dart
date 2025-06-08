class CakeModel {
  final String id; // <--- Tambahkan ini
  final String name;
  final String flavour;
  final String image;
  final double price;
  final String bgColor;
  final String description;
  final double rating;

  CakeModel({
    required this.id, // <---
    required this.name,
    required this.flavour,
    required this.image,
    required this.price,
    required this.bgColor,
    required this.description,
    required this.rating,
  });

  factory CakeModel.fromMap(Map<String, dynamic> map, String id) {
    return CakeModel(
      id: id, // <--- Ambil dari doc.id
      name: map['name'] ?? '',
      flavour: map['flavour'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] as num).toDouble(),
      bgColor: map['bgColor'] ?? '#FFFFFF',
      description: map['description'] ?? '',
      rating: (map['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'flavour': flavour,
      'image': image,
      'price': price,
      'bgColor': bgColor,
      'description': description,
      'rating': rating,
      // Jangan tambahkan id ke sini, biarkan Firestore yang kelola
    };
  }
}
