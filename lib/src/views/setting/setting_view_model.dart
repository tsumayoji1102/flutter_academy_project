import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/firebase_auth_service.dart';

final settingViewModelProvider = ChangeNotifierProvider(
  (ref) => SettingViewModel(
    ref.watch(firebaseAuthServiceProvider),
  ),
);

class SettingViewModel extends ChangeNotifier {
  SettingViewModel(this._authService);
  final FirebaseAuthService _authService;

  bool _isProgress = false;
  bool get isProgress => _isProgress;

  void setIsProgress(bool isProgress) {
    _isProgress = isProgress;
    notifyListeners();
  }

  Future<void> logOut() => _authService.logOut();
}
