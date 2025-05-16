import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithPhone(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<void> verifyPhone(
    String phone,
    Function(String verificationId) codeSent,
    Function(FirebaseAuthException) verificationFailed,
    Function(PhoneAuthCredential) autoVerify,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: autoVerify,
      verificationFailed: verificationFailed,
      codeSent: (_, vid) => codeSent(vid),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<void> signOut() => _auth.signOut();
}