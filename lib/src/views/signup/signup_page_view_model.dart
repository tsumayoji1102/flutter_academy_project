import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/firebase_auth_service.dart';
import '../../util/log.dart';

final signUpViewModelProvider = ChangeNotifierProvider<SignUpPageViewModel>(
  (ref) => SignUpPageViewModel(
    ref.watch(firebaseAuthServiceProvider),
  ),
);

class SignUpPageViewModel extends ChangeNotifier {
  SignUpPageViewModel(this._authService);
  final FirebaseAuthService _authService;

  bool _isProgress = false;
  bool get isProgress => _isProgress;

  void setIsProgress(bool isProgress) {
    _isProgress = isProgress;
    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    try {
      setIsProgress(true);
      await _authService.signUp(email: email, password: password);
      setIsProgress(false);
    } catch (e) {
      setIsProgress(false);
      Log.error(e);
      rethrow;
    }
  }
}
