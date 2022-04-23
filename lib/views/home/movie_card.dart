import 'package:flutter/material.dart';

import '../../model/movie_model.dart';
import '../datail/detail_view.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({required this.movie, Key? key}) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailView(
              movie: movie,
            ),
          ),
        );
      },
      // ここからカード見た目
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border.symmetric(
            horizontal: BorderSide(width: 0.5, color: Colors.black26),
          ),
        ),
        height: 100,
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            children: [
              // 画像
              Container(
                height: 80,
                width: 80,
                color: Colors.purple,
              ),
              // 紹介
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          movie.title!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          movie.fetchOverView(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
