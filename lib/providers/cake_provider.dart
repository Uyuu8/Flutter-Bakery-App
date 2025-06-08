import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cake_model.dart';

class CakeProvider with ChangeNotifier {
  List<CakeModel> _cakes = [];
  bool _isLoading = false;

  List<CakeModel> get cakes => _cakes;
  bool get isLoading => _isLoading;

  Future<void> fetchCakes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance.collection('cakes').get();
      _cakes = snapshot.docs.map((doc) {
        return CakeModel.fromMap(doc.data(), doc.id); // 👈 Masukkan doc.id ke model
      }).toList();
    } catch (e) {
      print('Error fetching cakes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tambahan opsional (bisa kamu sesuaikan)
  Future<void> deleteCake(String id) async {
    try {
      await FirebaseFirestore.instance.collection('cakes').doc(id).delete();
      _cakes.removeWhere((cake) => cake.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting cake: $e');
    }
  }

  Future<void> addCake(CakeModel cake) async {
    try {
      final docRef = await FirebaseFirestore.instance.collection('cakes').add(cake.toMap());
      final newCake = CakeModel.fromMap(cake.toMap(), docRef.id);
      _cakes.add(newCake);
      notifyListeners();
    } catch (e) {
      print('Error adding cake: $e');
    }
  }

  Future<void> updateCake(CakeModel cake) async {
    try {
      await FirebaseFirestore.instance.collection('cakes').doc(cake.id).update(cake.toMap());
      final index = _cakes.indexWhere((c) => c.id == cake.id);
      if (index != -1) {
        _cakes[index] = cake;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating cake: $e');
    }
  }
}
