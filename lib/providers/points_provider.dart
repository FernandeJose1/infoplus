import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PointsProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  int _points = 0;

  int get points => _points;

  /// Carrega os pontos atuais do usuário do Firestore
  Future<void> loadPoints(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    _points = doc.data()?['points'] ?? 0;
    notifyListeners();
  }

  /// Adiciona pontos ao usuário e persiste no Firestore
  Future<void> addPoints(String userId, int delta) async {
    _points += delta;
    await _firestore.collection('users').doc(userId).update({'points': _points});
    notifyListeners();
  }
}