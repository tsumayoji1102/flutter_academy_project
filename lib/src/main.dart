import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_builder_manager.dart';
import 'home_page.dart';
import 'views/home/home_page.dart';
import 'views/login/login_page.dart';
import 'views/setting/setting_page.dart';
import '../firebase_options.dart';
import 'views/home/home_page_view_model.dart';

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
      home: const AuthBuilder(),
    );
  }
}

class AuthBuilder extends ConsumerStatefulWidget {
  const AuthBuilder({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthBuilder> createState() => _AuthBuilderState();
}

class _AuthBuilderState extends ConsumerState<AuthBuilder> {
  @override
  Widget build(BuildContext context) {
    final authBuilderManager = ref.watch(authBuilderManagerProvider);
    return authBuilderManager.isLoggedIn ? const HomePage() : const LoginPage();
  }
}
