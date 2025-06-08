import 'package:sweet_delights/models/cake_model.dart';

class Categories {
  final int id;
  final String name;
  final String image;
  final String tag;

  Categories({
    required this.id,
    required this.name,
    required this.image,
    required this.tag,
  });
}

List<Categories> categories = [
  Categories(id: 0, name: 'All Cakes', image: 'assets/icons/birthday-cake.svg', tag: 'all'),
  Categories(id: 1, name: 'Birthday', image: 'assets/icons/cake.svg', tag: 'birthday'),
  Categories(id: 2, name: 'Wedding', image: 'assets/icons/cupcake.svg', tag: 'wedding'),
  Categories(id: 3, name: 'Chocolate', image: 'assets/icons/donut.svg', tag: 'chocolate'),
  Categories(id: 4, name: 'Custom', image: 'assets/icons/cake01.svg', tag: 'custom'),
];

// ✅ Use CakeModel, not Cakes
List<CakeModel> getFilteredCakes(String tag, List<CakeModel> allCakes) {
  if (tag == 'all') return allCakes;

  final category = categories.firstWhere((c) => c.tag == tag, orElse: () => categories[0]);

  return allCakes.where((cake) {
    switch (tag) {
      case 'birthday':
      case 'wedding':
      case 'chocolate':
        return cake.flavour.toLowerCase() == category.name.toLowerCase();
      case 'custom':
        return cake.price >= 299.99;
      default:
        return true;
    }
  }).toList();
}
