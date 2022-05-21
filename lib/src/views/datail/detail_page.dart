import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/movie_model.dart';
import '../../util/paths.dart';
import 'comment_card.dart';
import 'detail_page_view_model.dart';
import 'post_comment_dialog.dart';

class DetailView extends ConsumerWidget {
  const DetailView({required this.movie, Key? key}) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(detailPageViewModelProvider);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(movie.title!),
      // ),
      body: SafeArea(
        child: ListView.builder(
          itemCount:
              viewModel.comments.isNotEmpty ? viewModel.comments.length + 2 : 2,
          itemBuilder: (_, index) {
            if (index == 0) {
              return Container(
                color: Colors.black87,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        color: Colors.purple,
                        width: double.infinity,
                        height: 500,
                        child: movie.posterPath!.isNotEmpty
                            ? CachedNetworkImage(
                                fit: BoxFit.fitWidth,
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                  ),
                                ),
                                imageUrl: Paths.movieImageUrl(movie.posterPath),
                                errorWidget: (a, b, c) =>
                                    Image.asset('lib/assets/movie.png'),
                              )
                            : Image.asset('lib/assets/movie.png'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Center(
                        child: Text(
                          movie.title!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        movie.fetchOverView(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              );
            } else {
              // からの時には読み込みボタンを追加
              if (viewModel.comments.isEmpty) {
                return GestureDetector(
                  onTap: () async {
                    viewModel.setIsProgress(true);
                    await viewModel.fetchComments(movie.id.toString());
                    viewModel.setIsProgress(false);
                  },
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: viewModel.isProgress
                          ? const CircularProgressIndicator()
                          : viewModel.commentsExisted
                              ? const Text(
                                  'コメントを表示',
                                  style: TextStyle(color: Colors.lightBlue),
                                )
                              : const Text(
                                  'コメントはありませんでした。',
                                  style: TextStyle(color: Colors.lightBlue),
                                ),
                    ),
                  ),
                );
                // 空白
              } else if (index == viewModel.comments.length + 1) {
                return const SizedBox(height: 80);
              } else {
                return CommentCard(
                  comment: viewModel.comments[index - 1],
                );
              }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => PostCommentDialog(onTap: (subTitle, comment) async {
              await viewModel.postComment(
                movie.id.toString(),
                subTitle,
                comment,
              );
            }),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.announcement),
      ),
    );
  }
}
