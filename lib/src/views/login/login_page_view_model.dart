import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/firebase_auth_service.dart';
import '../../util/log.dart';

final loginPageViewModelProvider = ChangeNotifierProvider<LoginPageViewModel>(
  (ref) => LoginPageViewModel(
    ref.watch(firebaseAuthServiceProvider),
  ),
);

class LoginPageViewModel extends ChangeNotifier {
  LoginPageViewModel(this._authService);
  final FirebaseAuthService _authService;

  bool _isProgress = false;
  bool get isProgress => _isProgress;

  void setIsProgress(bool isProgress) {
    _isProgress = isProgress;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.login(
        email: email,
        password: password,
      );
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }
}
