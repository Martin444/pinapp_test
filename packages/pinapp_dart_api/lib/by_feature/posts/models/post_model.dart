import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;
  final bool isLiked;

  const PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isLiked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    bool? isLiked,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [id, userId, title, body, isLiked];
}
