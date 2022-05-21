import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../home_page.dart';
import '../shared_components/error_dialog.dart';
import '../shared_components/theme_button.dart';
import '../signup/signup_page.dart';
import 'login_page_view_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginPageViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ログイン',
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
                const SizedBox(
                  height: 20,
                ),
                // ログインボタン
                ThemeButton(
                  title: 'ログイン',
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  onTap: () async {
                    // ログイン処理が入る
                    try {
                      if (_emailTextController.text.isEmpty ||
                          _passwordTextController.text.isEmpty) {
                        await showDialog(
                          context: context,
                          builder: (_) => const ErrorDialog(
                            title: 'ログインエラー',
                            message: '空欄を入力してください。',
                          ),
                        );
                        return;
                      }
                      // ログイン処理
                      viewModel.setIsProgress(true);
                      await viewModel.login(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      );
                      viewModel.setIsProgress(false);
                      await Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false,
                      );
                    } on FirebaseAuthException catch (e) {
                      viewModel.setIsProgress(false);
                      final code = e.code;
                      var errorMessage = '';
                      switch (code) {
                        case 'invalid-email':
                          errorMessage = 'メールアドレスが不適切です。\n正しく入力してください。';
                          break;
                        // 多分こない
                        case 'user-disabled':
                          errorMessage = 'こちらのユーザーは\n退会しております。';
                          break;
                        case 'user-not-found':
                          errorMessage = 'ユーザーが存在しません。';
                          break;
                        case 'wrong-password':
                          errorMessage = 'パスワードが\n間違っております。';
                          break;
                        case 'too-many-requests':
                          errorMessage = 'ログインを複数回間違えております。';
                          break;
                        default:
                          break;
                      }
                      await showDialog(
                        context: context,
                        builder: (_) => ErrorDialog(
                          title: 'ログインエラー',
                          message: errorMessage,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                // 新規登録
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignUpPage(),
                      ),
                    );
                  },
                  child: const Text(
                    '新規登録はこちら',
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
