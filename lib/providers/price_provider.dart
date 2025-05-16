import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/price.dart';

class PriceProvider extends ChangeNotifier {
  final _pricesRef = FirebaseFirestore.instance.collection('prices');
  List<Price> _prices = [];

  List<Price> get prices => _prices;

  Future<void> fetchPrices(String province) async {
    final snapshot = await _pricesRef.where('province', isEqualTo: province).get();
    _prices = snapshot.docs.map((doc) => Price.fromJson(doc.data())).toList();
    notifyListeners();
  }

  List<Price> pricesByProvince(String province) {
    return _prices.where((p) => p.province == province).toList();
  }

  Future<void> addPrice(Price price) async {
    await _pricesRef.doc(price.id).set(price.toJson());
    await fetchPrices(price.province);
  }

  Future<void> deletePrice(String id) async {
    await _pricesRef.doc(id).delete();
    _prices.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}