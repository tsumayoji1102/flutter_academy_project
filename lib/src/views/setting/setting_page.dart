import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../views/setting/setting_view_model.dart';
import '../login/login_page.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({Key? key, required this.userName}) : super(key: key);

  final String userName;

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(settingViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '設定',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        color: Colors.black12,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            // SettingCell(
            //   title: 'テーマカラーの変更',
            //   onTap: () {},
            //   child: Container(
            //     height: 25,
            //     width: 25,
            //     decoration: BoxDecoration(
            //       color: Colors.lightBlue,
            //       borderRadius: BorderRadius.circular(12.5),
            //     ),
            //   ),
            // ),
            // 名前変更
            SettingCell(
              title: '名前の変更',
              onTap: () {},
              child: SizedBox(
                width: 150,
                height: 25,
                child: TextField(
                  controller: _nameController,
                  onChanged: (value) async {
                    await viewModel.updateName(value);
                  },
                  maxLines: 1,
                ),
              ),
            ),
            // ログアウト
            SettingCell(
              title: 'ログアウト',
              onTap: () async {
                viewModel.setIsProgress(true);
                await viewModel.logOut();
                viewModel.setIsProgress(false);
                await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingCell extends StatelessWidget {
  const SettingCell({
    Key? key,
    required this.title,
    required this.onTap,
    this.child,
  }) : super(key: key);

  final String title;
  final Function onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border.symmetric(
            horizontal: BorderSide(width: 0.25, color: Colors.black26),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 20),
          child: child != null
              ? Stack(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: child,
                    )
                  ],
                )
              : Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
        ),
      ),
    );
  }
}
