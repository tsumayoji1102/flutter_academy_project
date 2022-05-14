import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/firebase_auth_service.dart';
import '../../util/log.dart';

final loginPageViewModelProvider = Provider<LoginPageViewModel>(
  (ref) => LoginPageViewModel(
    ref.watch(firebaseAuthServiceProvider),
  ),
);

class LoginPageViewModel {
  LoginPageViewModel(this._authService);
  final FirebaseAuthService _authService;

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
