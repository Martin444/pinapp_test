import 'package:pinapp_dart_api/by_feature/likes/data/repository/like_repository.dart';

class GetLikedPostsUseCase {
  final LikeRepository _likeRepository;

  const GetLikedPostsUseCase(this._likeRepository);

  Future<Set<int>> execute() async {
    return await _likeRepository.getLikedPosts();
  }
}
