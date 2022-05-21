import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'service/firebase_auth_service.dart';

final authBuilderManagerProvider =
    ChangeNotifierProvider<AuthBuilderManager>((ref) {
  final authBuilderManager = AuthBuilderManager(
    ref.watch(firebaseAuthServiceProvider),
  );
  // ここで初期化、かつdisposeの処理を設定
  authBuilderManager.initialize();
  ref.onDispose(() {
    print('authBuilder dispose()');
    authBuilderManager.dispose();
  });
  return authBuilderManager;
});

class AuthBuilderManager extends ChangeNotifier {
  AuthBuilderManager(this._authService);
  final FirebaseAuthService _authService;

  bool isLoggedIn = false;
  late StreamSubscription<String> isLoggedInStream;

  void initialize() {
    isLoggedInStream = _authService.authState.listen((value) {
      setIsLoggedIn(value.isNotEmpty);
    });
  }

  void setIsLoggedIn(bool isLoggedIn) {
    this.isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  @override
  void dispose() {
    isLoggedInStream.cancel();
    super.dispose();
  }
}
