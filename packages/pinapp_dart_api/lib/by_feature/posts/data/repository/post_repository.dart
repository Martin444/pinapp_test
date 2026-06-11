import 'package:pinapp_dart_api/by_feature/posts/models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPosts();
}
