import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../util/log.dart';

final firebaseAuthServiceProvider =
    Provider<FirebaseAuthService>((ref) => FirebaseAuthService());

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ログイン状態を保持
  Stream<String> get authState => _auth.authStateChanges().map((_user) {
        return _user != null ? _user.uid : '';
      });

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }
}
