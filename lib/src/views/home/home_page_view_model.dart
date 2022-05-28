import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/movie_model.dart';
import '../../service/tmdb_service.dart';
import '../../util/log.dart';

final homePageViewModelProvider = ChangeNotifierProvider<HomeViewModel>(
  (ref) => HomeViewModel(
    ref.watch(tmdbServiceProvider),
  ),
);

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._tmdbService);
  final TMDBService _tmdbService;

  List<Movie> movies = [];

  // 検索で保持しておく値
  String lastSearchText = '';
  int pageIndex = 0;

  // 状態
  bool _isProgress = false;
  bool get isProgress => _isProgress;

  // 状態（ツギヲヒョウジ）
  bool _isMiniProgress = false;
  bool get isMiniProgress => _isMiniProgress;
  bool isNoNextPage = false;

  void setIsMiniProgress(bool isProgress) {
    _isMiniProgress = isProgress;
    notifyListeners();
  }

  void setIsProgress(bool isProgress) {
    _isProgress = isProgress;
    notifyListeners();
  }

  /// 状態を更新はしない（今のところ）
  void setLastSearch(String text, int pageIndex) {
    lastSearchText = text;
    this.pageIndex = pageIndex;
  }

  void updateScreen() {
    notifyListeners();
  }

  /// 新規での検索はここから行う。
  Future<void> searchNewMovies(String title) async {
    try {
      if (lastSearchText == title) {
        print('検索の必要なし');
        return;
      }
      setIsProgress(true);
      isNoNextPage = false;
      final movies = await _tmdbService.fetchTmdbData(title, 1);
      this.movies = movies;
      if (movies.length < 20) {
        isNoNextPage = true;
      }
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
      setIsMiniProgress(true);
      pageIndex++;
      final movies =
          await _tmdbService.fetchTmdbData(lastSearchText, pageIndex);
      this.movies += movies;
      // 20以下だったら次なし
      if (movies.length < 20) {
        isNoNextPage = true;
      }
      // 最終検索を保持しておく
      setLastSearch(lastSearchText, pageIndex);
      notifyListeners();
    } catch (e) {
      Log.error(e);
      rethrow;
    } finally {
      setIsMiniProgress(false);
    }
  }
}
