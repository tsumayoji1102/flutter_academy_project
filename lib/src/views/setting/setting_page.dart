import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            SettingCell(
              title: 'テーマカラーの変更',
              onTap: () {},
              rightWidget: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(12.5),
                ),
              ),
            ),
            // ログアウト
            SettingCell(
              title: 'ログアウト',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class SettingCell extends StatelessWidget {
  SettingCell({
    Key? key,
    required this.title,
    required this.onTap,
    this.rightWidget,
  }) : super(key: key);

  final String title;
  final Function onTap;
  final Widget? rightWidget;

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
          margin: const EdgeInsets.only(left: 10),
          child: rightWidget != null
              ? Stack(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: rightWidget,
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
