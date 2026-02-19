import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

class AuthController {
  AuthController(this._auth);

  final FirebaseAuth _auth;
  String? _verificationId;

  Future<void> sendOtp({required String phoneNumber, required void Function(String) onCodeSent}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async => _auth.signInWithCredential(credential),
      verificationFailed: (e) => throw Exception(e.message),
      codeSent: (verificationId, _) {
        _verificationId = verificationId;
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) => _verificationId = verificationId,
    );
  }

  Future<void> verifyOtp(String smsCode) async {
    final id = _verificationId;
    if (id == null) throw Exception('OTP has not been requested yet.');
    final credential = PhoneAuthProvider.credential(verificationId: id, smsCode: smsCode);
    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() => _auth.signOut();
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.watch(firebaseAuthProvider));
});
