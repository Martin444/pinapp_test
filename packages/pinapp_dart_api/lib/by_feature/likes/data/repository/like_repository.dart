abstract class LikeRepository {
  Future<Set<int>> getLikedPosts();

  Future<bool> toggleLike(int postId);

  Future<bool> isLiked(int postId);
}
