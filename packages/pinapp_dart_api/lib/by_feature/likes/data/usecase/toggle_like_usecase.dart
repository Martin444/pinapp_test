import 'package:pinapp_dart_api/by_feature/likes/data/repository/like_repository.dart';

class ToggleLikeUseCase {
  final LikeRepository _likeRepository;

  const ToggleLikeUseCase(this._likeRepository);

  Future<bool> execute(int postId) async {
    return await _likeRepository.toggleLike(postId);
  }
}
