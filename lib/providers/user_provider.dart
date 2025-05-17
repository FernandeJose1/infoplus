import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(UserModel user) async {
    final docRef = _firestore.collection('users').doc(user.id);
    await docRef.set(user.toMap());
  }

  Future<UserModel?> getUserByPhone(String phoneNumber) async {
    final query = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return UserModel.fromMap(query.docs.first.data());
  }
}