import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/retry.dart';
import '../../model/movie_model.dart';
import 'home_view_model.dart';

final homeViewModelProvider =
    ChangeNotifierProvider<HomeViewModel>((ref) => HomeViewModel());

class HomeViewModel extends ChangeNotifier {
  late List<Movie> movies = [];

  Future<void> fetchData() async {
    try {
      const category = '/Hospital';
      final results = await http.get(Uri.parse(
          'https://api.data.metro.tokyo.lg.jp/v1/$category?limit=10'));
      print(results);
      final parsed = jsonDecode(results.body);
      print(parsed);
      final hospitalDataList = parsed[0];
      // final hospitalList = <Hospital>[];
      // for (var data in hospitalDataList) {
      //   final hospital = Hospital.fromMap(data);
      //   print(hospital.toString());
      //   hospitalList.add(hospital);
      // }
      // viewModel.setHospitalList(hospitalList);
      // final practice = Practice.fromJson(parsed);
      // practice.toMap();
    } catch (e) {
      print('Error in fetchData(): $e');
      rethrow;
    }
  }

  // 実験用
  Future<void> fetchTmdbData() async {
    try {
      const category = '/Hospital';
      final results = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/search/movie?api_key=c4470d4ccd101e384cf2b432a14777ed&language=ja&query=LEON&page=2'),
      );
      print(results);
      final parsed = jsonDecode(results.body);
      print(parsed);
      final movieResults = parsed['results'] as List<dynamic>;
      print('count: ${movieResults.length}');
      // final list = [];
      // for (var i = 0; i < movieResults.length - 1; i++) {
      //   print('i: $i');
      //   print(movieResults[i]);
      //   final movie = Movie.fromJson(movieResults[i]);
      //   list.add(movie);
      // }
      final movies = movieResults.map((data) => Movie.fromJson(data)).toList();
      print('success');
      this.movies = movies;
      notifyListeners();
      // final hospitalList = <Hospital>[];
      // for (var data in hospitalDataList) {
      //   final hospital = Hospital.fromMap(data);
      //   print(hospital.toString());
      //   hospitalList.add(hospital);
      // }
      // viewModel.setHospitalList(hospitalList);
      // final practice = Practice.fromJson(parsed);
      // practice.toMap();
    } catch (e) {
      print('Error in fetchData(): $e');
      rethrow;
    }
  }

  Future<void> postSlackData(String message) async {
    try {
      var client = RetryClient(http.Client(),
          when: (response) => response.statusCode == 404);
      await postMap(client, message);
      // var list = <Future>[];
      // for(var map in maps){
      //   final post = Future(() async => postMap(client));
      //   list.add(post);
      // }
      // await Future.wait(list);
    } catch (e) {
      print('Error in postData(): $e');
      rethrow;
    }
  }

  Future<void> postMap(RetryClient client, String message) async {
    try {
      // int形などを含んでいる場合、mapsのencodeが必要
      print(message);
      // await client.post(
      //     Uri.parse('https://hooks.slack.com/services/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'),
      //     body: json.encode({
      //       'text': '19_塩見のiPhoneから送信 \n$message',
      //     }),
      // );

    } catch (e) {
      print('Error in post(): $e');
      rethrow;
    }
  }
}
