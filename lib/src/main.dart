import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/retry.dart';
import 'package:tmdb_project/src/views/home/home_page.dart';
import 'package:tmdb_project/src/views/setting/setting_page.dart';
import '../firebase_options.dart';
import 'views/home/home_page.dart';
import 'views/home/home_page_view_model.dart';
import 'views/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _counter = 0;

  // いろいろと実験用ボタン
  Future<void> _incrementCounter(HomeViewModel viewModel) async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => const LoginPage(),
    //   ),
    // );
    // await viewModel.fetchTmdbData();
    // _counter++;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homePageViewModelProvider);
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
                  builder: (_) => SettingPage(),
                ),
              ),
              child: const Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: const Center(
        child: HomePage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(viewModel),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
