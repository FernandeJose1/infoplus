import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as app_user;

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? firebaseUser;
  app_user.UserModel? userProfile;
  String? verificationId;
  bool loading = false;

  bool get isAdmin => userProfile?.role == 'admin';

  Future<void> sendCode(String phone) async {
    loading = true;
    notifyListeners();

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await _signInWithCredential(credential);
      },
      verificationFailed: (e) {
        loading = false;
        notifyListeners();
        debugPrint('Erro: ${e.message}');
      },
      codeSent: (String vid, int? resendToken) {
        verificationId = vid;
        loading = false;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String vid) {
        verificationId = vid;
      },
    );
  }

  Future<void> verifyCode(String smsCode) async {
    if (verificationId == null) return;

    loading = true;
    notifyListeners();

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: smsCode,
    );

    await _signInWithCredential(credential);
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    final result = await _auth.signInWithCredential(credential);
    firebaseUser = result.user;
    await fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    if (firebaseUser == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(firebaseUser!.uid)
        .get();

    if (snapshot.exists) {
      userProfile = app_user.UserModel.fromMap(snapshot.data()!);
    } else {
      userProfile = app_user.UserModel(
        id: firebaseUser!.uid,
        phoneNumber: firebaseUser!.phoneNumber ?? '',
        name: '',
        province: '',
      );
      await _firestore.collection('users').doc(firebaseUser!.uid).set(userProfile!.toMap());
    }

    loading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    firebaseUser = null;
    userProfile = null;
    notifyListeners();
  }
}