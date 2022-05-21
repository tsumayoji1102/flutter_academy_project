import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/log.dart';

final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setData(
      String collectionPath, String id, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(id).set(
            data,
            SetOptions(
              merge: true,
            ),
          );
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }

  Future<void> addCommentData(
      String collectionPath, Map<String, dynamic> data) async {
    try {
      final ref = _db.collection(collectionPath).doc();
      final documentId = ref.id;
      data['commentId'] = documentId;
      await ref.set(
        data,
        SetOptions(merge: true),
      );
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchDataList(
      String collectionPath) async {
    try {
      // 作成順に並び替え
      final snapshot = await _db
          .collection(collectionPath)
          .orderBy('createdAt', descending: true)
          .get();
      final dataList = snapshot.docs.map((doc) => doc.data()).toList();
      print('data.length: ${dataList.length}');
      return dataList;
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }
}
