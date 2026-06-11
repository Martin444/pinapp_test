import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  final int id;
  final int postId;
  final String name;
  final String email;
  final String body;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      postId: json['postId'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'name': name,
      'email': email,
      'body': body,
    };
  }

  @override
  List<Object?> get props => [id, postId, name, email, body];
}
