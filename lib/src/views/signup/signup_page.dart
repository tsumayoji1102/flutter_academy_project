import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../home_page.dart';
import '../../views/signup/signup_page_view_model.dart';

import '../shared_components/error_dialog.dart';
import '../shared_components/theme_button.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  late TextEditingController _rePasswordTextController;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _rePasswordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _rePasswordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(signUpViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '新規登録',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: ModalProgressHUD(
        inAsyncCall: viewModel.isProgress,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // メールアドレス
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('メールアドレス'),
                      ),
                      TextField(
                        controller: _emailTextController,
                      )
                    ],
                  ),
                ),
                // パスワード
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('パスワード'),
                      ),
                      TextField(
                        controller: _passwordTextController,
                        obscureText: true,
                      )
                    ],
                  ),
                ),
                // パスワード
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('パスワード（再入力）'),
                      ),
                      TextField(
                        controller: _rePasswordTextController,
                        obscureText: true,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // 新規登録ボタン
                ThemeButton(
                  title: 'ユーザー作成',
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  onTap: () async {
                    // 新規登録処理が入る
                    if (_emailTextController.text.isEmpty ||
                        _passwordTextController.text.isEmpty ||
                        _rePasswordTextController.text.isEmpty) {
                      return;
                    }
                    if (_passwordTextController.text !=
                        _rePasswordTextController.text) {
                      await showDialog(
                        context: context,
                        builder: (_) => const ErrorDialog(
                          title: 'エラー',
                          message: '再入力したパスワードが一致しません。\n入力し直してください。',
                        ),
                      );
                      return;
                    }
                    try {
                      await viewModel.signUp(
                        _emailTextController.text,
                        _passwordTextController.text,
                      );
                      await Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    } on FirebaseAuthException catch (e) {
                      final code = e.code;
                      var errorMessage = '';
                      switch (code) {
                        case 'email-already-in-use':
                          errorMessage = 'そのメールアドレスはすでに\n使用されています。';
                          break;
                        case 'invalid-email':
                          errorMessage = '不適切なメールアドレスです。';
                          break;
                        case 'operation-not-allowed':
                          errorMessage = '許可されていないことを\nしようとしています。';
                          break;
                        case 'weak-password':
                          errorMessage = 'パスワードを強固なものに\n設定してください。';
                          break;
                      }
                      await showDialog(
                        context: context,
                        builder: (_) => ErrorDialog(
                          title: 'エラー',
                          message: errorMessage,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
