import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/movie_model.dart';
import '../../util/paths.dart';

class DetailView extends StatelessWidget {
  const DetailView({required this.movie, Key? key}) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(movie.title!),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
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
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Center(
                  child: Text(
                    movie.title!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(movie.fetchOverView()),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.circle),
      ),
    );
  }
}
