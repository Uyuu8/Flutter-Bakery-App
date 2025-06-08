class Category {
  final String id;
  final String name;
  final String image;
  final String tag;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.tag,
  });

  factory Category.fromMap(Map<String, dynamic> data, String documentId) {
    return Category(
      id: documentId,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      tag: data['tag'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'tag': tag,
    };
  }
}
