import 'package:flutter/material.dart';
import 'package:sweet_delights/models/cake_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<CakeModel> _favorites = [];

  List<CakeModel> get favorites => _favorites;

  bool isFavorite(CakeModel cake) {
    return _favorites.any((item) => item.name == cake.name);
  }

  void toggleFavorite(CakeModel cake) {
    if (isFavorite(cake)) {
      _favorites.removeWhere((item) => item.name == cake.name);
    } else {
      _favorites.add(cake);
    }
    notifyListeners();
  }
}
