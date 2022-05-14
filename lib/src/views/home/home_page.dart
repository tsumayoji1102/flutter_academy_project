import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'home_page_view_model.dart';
import 'movie_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late TextEditingController _searchTextController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(homePageViewModelProvider);
    return ModalProgressHUD(
      inAsyncCall: viewModel.isProgress,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 探す
          Container(
            width: double.infinity,
            height: 40,
            margin: const EdgeInsets.all(10),
            child: CupertinoSearchTextField(
              controller: _searchTextController,
              onChanged: (value) {
                if (value.isEmpty) {
                  //　検索がないときは初期画面を出す
                  viewModel.updateScreen();
                }
                //viewModel.updateScreen();
              },
              onSubmitted: (value) async {
                await viewModel.searchNewMovies(value);
              },
            ),
          ),
          // リストで映画表示
          Expanded(
            flex: 12,
            child: (viewModel.movies.isEmpty ||
                    _searchTextController.text.isEmpty)
                ? const NoMovieScreen()
                : Container(
                    color: Colors.white,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: viewModel.movies.isEmpty
                          ? 0
                          : viewModel.movies.length + 2,
                      itemBuilder: (_, index) {
                        // 検索結果の件数
                        if (index == 0) {
                          return Container(
                            color: Colors.white,
                            width: double.infinity,
                            height: 40,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, bottom: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  '${viewModel.lastSearchText}の検索結果: ${viewModel.movies.length}件'),
                            ),
                          );
                          // 追加のボタンを表示
                        } else if (index == viewModel.movies.length + 1) {
                          if (viewModel.movies.length % 20 == 0) {
                            return GestureDetector(
                              onTap: () async {
                                await viewModel.addNewMovies();
                              },
                              child: Container(
                                color: Colors.white,
                                width: double.infinity,
                                height: 60,
                                child: const Center(
                                  child: Text(
                                    'さらに表示',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                          // 映画
                        } else {
                          // カードを表示
                          final movie = viewModel.movies[index - 1];
                          return MovieCard(
                            movie: movie,
                          );
                        }
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class NoMovieScreen extends StatelessWidget {
  const NoMovieScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            '早速映画を検索\nしてみましょう！',
            style: TextStyle(
                color: Colors.black38,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}