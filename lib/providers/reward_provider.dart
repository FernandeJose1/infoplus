import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reward.dart';

class RewardProvider extends ChangeNotifier {
  final _rewardsRef = FirebaseFirestore.instance.collection('rewards');
  List<Reward> _rewards = [];
  String? errorMessage;

  List<Reward> get rewards => _rewards;

  Future<void> fetchRewards() async {
    try {
      final snapshot = await _rewardsRef.get();
      _rewards = snapshot.docs.map((doc) => Reward.fromJson(doc.data())).toList();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Erro ao buscar brindes: $e';
    }
    notifyListeners();
  }

  Future<void> addReward(Reward reward) async {
    try {
      await _rewardsRef.doc(reward.id).set(reward.toJson());
      await fetchRewards();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Erro ao adicionar brinde: $e';
      notifyListeners();
    }
  }

  Future<void> deleteReward(String id) async {
    try {
      await _rewardsRef.doc(id).delete();
      await fetchRewards();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Erro ao deletar brinde: $e';
      notifyListeners();
    }
  }
}