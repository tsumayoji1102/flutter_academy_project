import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../model/movie_model.dart';

final tmdbServiceProvider = Provider<TMDBService>((ref) => TMDBService());

class TMDBService {
  /// 映画リストを取得し、返す
  Future<List<Movie>> fetchTmdbData(String title, int pageIndex) async {
    try {
      final results = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/search/movie?api_key=c4470d4ccd101e384cf2b432a14777ed&language=ja&region=JP&query=$title&page=$pageIndex'),
      );
      print(results);
      final parsed = jsonDecode(results.body);
      print(parsed);
      final movieResults = parsed['results'] as List<dynamic>;
      print('count: ${movieResults.length}');
      final movies = movieResults.map((data) => Movie.fromJson(data)).toList();
      print('success');
      return movies;
    } catch (e) {
      print('Error in fetchData(): $e');
      rethrow;
    }
  }
}
