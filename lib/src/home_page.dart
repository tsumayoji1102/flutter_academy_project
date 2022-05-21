import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_project/src/service/firebase_auth_service.dart';
import 'views/setting/setting_page.dart';

import 'views/home/home_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(firebaseAuthServiceProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '映画の検索',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingPage(
                    userName: authService.displayName,
                  ),
                ),
              ),
              child: const Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: const Center(
        child: HomePageView(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _incrementCounter(),
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  // いろいろと実験用ボタン
  Future<void> _incrementCounter() async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => const LoginPage(),
    //   ),
    // );
    // await viewModel.fetchTmdbData();
    // _counter++;
  }
}
