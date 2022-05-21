class CommentModel {
  CommentModel({
    required this.commentId,
    required this.userId,
    this.userName = 'NoName',
    required this.content,
    required this.subTitle,
    this.stars = 0,
    this.starList = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CommentModel.initialData();
    return CommentModel(
      commentId: json['commentId'],
      userId: json['userId'],
      content: json['content'],
      subTitle: json['subTitle'],
      createdAt: json['createdAt'].toDate(),
      updatedAt: json['updatedAt'].toDate(),
      userName: json['userName'],
      stars: json['stars'],
      starList: List.from(json['starList']),
    );
  }

  factory CommentModel.initialData() {
    return CommentModel(
      commentId: '',
      userId: '',
      content: '',
      subTitle: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'userId': userId,
      'content': content,
      'subTitle': subTitle,
      'userName': userName ?? '',
      'stars': stars ?? 0,
      'starList': starList,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  final String commentId;
  final String userId;
  final String? userName;
  final String subTitle;
  final String content;
  final int? stars;
  final List<String>? starList;
  final DateTime createdAt;
  final DateTime updatedAt;
}
