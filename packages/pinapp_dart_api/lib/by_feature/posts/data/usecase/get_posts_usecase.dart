import 'package:pinapp_dart_api/by_feature/posts/models/post_model.dart';
import 'package:pinapp_dart_api/by_feature/posts/data/repository/post_repository.dart';
import 'package:pinapp_dart_api/by_feature/likes/data/repository/like_repository.dart';

class GetPostsUseCase {
  final PostRepository _postRepository;
  final LikeRepository _likeRepository;

  const GetPostsUseCase(this._postRepository, this._likeRepository);

  Future<List<PostModel>> execute() async {
    final posts = await _postRepository.getPosts();
    final likedPosts = await _likeRepository.getLikedPosts();
    return posts.map((post) => post.copyWith(
      isLiked: likedPosts.contains(post.id),
    )).toList();
  }
}
