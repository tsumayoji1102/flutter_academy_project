import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_view_model.dart';
import 'movie_card.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
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
    final viewModel = ref.watch(homeViewModelProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 探す
        Container(
          width: double.infinity,
          height: 40,
          margin: const EdgeInsets.all(10),
          child: CupertinoSearchTextField(
            controller: _searchTextController,
          ),
        ),
        // リストで映画表示
        Expanded(
          flex: 12,
          child: Container(
            color: Colors.black12,
            child: ListView.builder(
              controller: _scrollController,
              itemCount:
                  viewModel.movies.isEmpty ? 0 : viewModel.movies.length + 1,
              itemBuilder: (_, index) {
                if (index == viewModel.movies.length) {
                  // 追加のボタンを表示
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 60,
                      child: const Center(
                        child: Text(
                          '次の20件を表示',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  );
                } else {
                  // カードを表示
                  final movie = viewModel.movies[index];
                  return MovieCard(
                    movie: movie,
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
