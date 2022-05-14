import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/retry.dart';
import '../../model/movie_model.dart';
import '../../util/log.dart';
import 'home_page_view_model.dart';

final homePageViewModelProvider =
    ChangeNotifierProvider<HomeViewModel>((ref) => HomeViewModel());

class HomeViewModel extends ChangeNotifier {
  List<Movie> movies = [];

  // 検索で保持しておく値
  String lastSearchText = '';
  int pageIndex = 0;

  // 状態
  bool _isProgress = false;
  bool get isProgress => _isProgress;

  /// 状態を更新はしない（今のところ）
  void setLastSearch(String text, int pageIndex) {
    lastSearchText = text;
    this.pageIndex = pageIndex;
  }

  void setIsProgress(bool isProgress) {
    _isProgress = isProgress;
    notifyListeners();
  }

  void updateScreen() {
    notifyListeners();
  }

  /// 映画リストを取得し、返す
  Future<List<Movie>> _fetchTmdbData(String title, int pageIndex) async {
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
    } finally {
      setIsProgress(false);
    }
  }

  /// 新規での検索はここから行う。
  Future<void> searchNewMovies(String title) async {
    try {
      if (lastSearchText == title) {
        print('検索の必要なし');
        return;
      }
      setIsProgress(true);
      final movies = await _fetchTmdbData(title, 1);
      this.movies = movies;
      // 最終検索結果を保持しておく
      setLastSearch(title, 1);
      notifyListeners();
    } catch (e) {
      Log.error(e);
      rethrow;
    } finally {
      setIsProgress(false);
    }
  }

  Future<void> addNewMovies() async {
    try {
      setIsProgress(true);
      pageIndex++;
      final movies = await _fetchTmdbData(lastSearchText, pageIndex);
      this.movies += movies;
      // 最終検索を保持しておく
      setLastSearch(lastSearchText, pageIndex);
      notifyListeners();
    } catch (e) {
      Log.error(e);
      rethrow;
    } finally {
      setIsProgress(false);
    }
  }
}
