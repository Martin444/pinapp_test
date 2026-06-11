import 'package:pinapp_dart_api/core/comments_channel.dart';
import 'package:pinapp_dart_api/by_feature/comments/models/comment_model.dart';
import 'package:pinapp_dart_api/by_feature/comments/data/repository/comment_repository.dart';

class CommentProvider extends CommentRepository {
  final CommentsPlatformChannel _channel;

  CommentProvider({CommentsPlatformChannel? channel})
      : _channel = channel ?? CommentsPlatformChannel();

  @override
  Future<List<CommentModel>> getComments(int postId) async {
    try {
      final List<dynamic> result = await _channel.getComments(postId);
      return result
          .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener comentarios: $e');
    }
  }
}
