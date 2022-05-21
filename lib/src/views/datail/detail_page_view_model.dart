import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/comment_model.dart';
import '../../service/firebase_auth_service.dart';
import '../../service/firestore_service.dart';
import '../../util/log.dart';
import '../../util/paths.dart';

final detailPageViewModelProvider =
    ChangeNotifierProvider.autoDispose<DetailPageViewModel>((ref) {
  return DetailPageViewModel(
    ref.watch(firestoreServiceProvider),
    ref.watch(firebaseAuthServiceProvider),
  );
});

class DetailPageViewModel extends ChangeNotifier {
  DetailPageViewModel(this._firestoreService, this._authService);
  final FirestoreService _firestoreService;
  final FirebaseAuthService _authService;

  List<CommentModel> comments = [];

  // 状態
  bool _isProgress = false;
  bool get isProgress => _isProgress;
  bool commentsExisted = true;

  void setIsProgress(bool isProgress) {
    _isProgress = isProgress;
    notifyListeners();
  }

  /// コメント取得
  Future<void> fetchComments(String movieId) async {
    try {
      final commentDataList = await _firestoreService
          .fetchDataList(Paths.movieCommentsPath(movieId));
      final commentList =
          commentDataList.map((data) => CommentModel.fromJson(data)).toList();
      comments = commentList;
      commentsExisted = commentList.isNotEmpty;
      notifyListeners();
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }

  /// 投稿
  Future<void> postComment(
      String movieId, String subTitle, String comment) async {
    try {
      final now = DateTime.now();
      final commentModel = CommentModel(
        commentId: '', // のちに設定される
        subTitle: subTitle,
        userId: _authService.currentUserId,
        userName: _authService.displayName,
        content: comment,
        createdAt: now,
        updatedAt: now,
      );
      await _firestoreService.addCommentData(
        Paths.movieCommentsPath(movieId),
        commentModel.toMap(),
      );
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }
}
