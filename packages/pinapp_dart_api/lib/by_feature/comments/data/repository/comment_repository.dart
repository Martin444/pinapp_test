import 'package:pinapp_dart_api/by_feature/comments/models/comment_model.dart';

abstract class CommentRepository {
  Future<List<CommentModel>> getComments(int postId);
}
