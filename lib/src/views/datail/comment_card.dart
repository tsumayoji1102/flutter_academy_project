import 'package:flutter/material.dart';

import '../../model/comment_model.dart';
import '../../util/time_to_string.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({Key? key, required this.comment}) : super(key: key);

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.black26, width: 0.5),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    comment.userName!.isNotEmpty
                        ? '${comment.userName!}さん'
                        : 'NoNameさん',
                    style: const TextStyle(
                        //color: Colors.white,
                        ),
                  ),
                )),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      TimeToString.timeToString(comment.createdAt),
                      style: const TextStyle(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                comment.subTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  //color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                comment.content,
                style: const TextStyle(
                    //color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
