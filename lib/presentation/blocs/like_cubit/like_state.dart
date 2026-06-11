import 'package:equatable/equatable.dart';

class LikeState extends Equatable {
  final Set<int> likedPosts;

  const LikeState({this.likedPosts = const <int>{}});

  @override
  List<Object?> get props => [likedPosts];

  bool isLiked(int postId) => likedPosts.contains(postId);
}
