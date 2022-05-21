import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared_components/theme_button.dart';

class PostCommentDialog extends StatefulWidget {
  const PostCommentDialog({Key? key, required this.onTap}) : super(key: key);

  final Function(String, String) onTap;
  @override
  _PostCommentDialogState createState() => _PostCommentDialogState();
}

class _PostCommentDialogState extends State<PostCommentDialog> {
  late TextEditingController _commentController;
  late TextEditingController _subTitleController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _subTitleController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _subTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              decoration: const InputDecoration(
                labelText: '見出しを入力',
                //hintText: "Some Hint",
              ),
              controller: _subTitleController,
              minLines: 1,
              maxLines: 3,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'コメントを入力',
                //hintText: "Some Hint",
              ),
              controller: _commentController,
              minLines: 1,
              maxLines: 3,
            ),
          ),
          ThemeButton(
            title: '投稿',
            onTap: () {
              //  時間がないため、ここでバリデーション
              if ((_subTitleController.text.isEmpty ||
                      _subTitleController.text.length >= 21) ||
                  (_commentController.text.isEmpty ||
                      _commentController.text.length >= 201)) {
                return;
              }
              widget.onTap(
                _subTitleController.text,
                _commentController.text,
              );
              Navigator.pop(context);
            },
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
