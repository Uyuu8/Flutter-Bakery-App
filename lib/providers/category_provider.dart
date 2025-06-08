import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryProvider {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('categories');

  Future<List<Category>> getCategories() async {
    final snapshot = await _ref.get();
    return snapshot.docs
        .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
