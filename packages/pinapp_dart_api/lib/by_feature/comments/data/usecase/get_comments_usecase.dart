import 'package:pinapp_dart_api/by_feature/comments/models/comment_model.dart';
import 'package:pinapp_dart_api/by_feature/comments/data/repository/comment_repository.dart';

class GetCommentsUseCase {
  final CommentRepository _commentRepository;

  const GetCommentsUseCase(this._commentRepository);

  Future<List<CommentModel>> execute(int postId) async {
    return await _commentRepository.getComments(postId);
  }
}
