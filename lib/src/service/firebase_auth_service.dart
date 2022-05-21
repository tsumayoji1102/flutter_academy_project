import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../util/log.dart';

final firebaseAuthServiceProvider =
    Provider<FirebaseAuthService>((ref) => FirebaseAuthService());

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId =>
      (_auth.currentUser != null) ? _auth.currentUser!.uid : '';

  String get displayName => (_auth.currentUser?.displayName != null)
      ? _auth.currentUser!.displayName!
      : '';

  // ログイン状態を保持
  Stream<String> get authState => _auth.authStateChanges().map(
        (_user) {
          return _user != null ? _user.uid : '';
        },
      );

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 名前を設定
      await _auth.currentUser?.updateDisplayName(currentUserId);
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

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }

  Future<void> updateName(String name) async {
    try {
      await _auth.currentUser?.updateDisplayName(name);
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }
}
