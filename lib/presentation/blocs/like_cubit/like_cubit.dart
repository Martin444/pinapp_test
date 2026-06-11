import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';
import 'package:pinapp_test/presentation/blocs/like_cubit/like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  final GetLikedPostsUseCase _getLikedPostsUseCase;
  final ToggleLikeUseCase _toggleLikeUseCase;

  LikeCubit({
    required GetLikedPostsUseCase getLikedPostsUseCase,
    required ToggleLikeUseCase toggleLikeUseCase,
  })  : _getLikedPostsUseCase = getLikedPostsUseCase,
        _toggleLikeUseCase = toggleLikeUseCase,
        super(const LikeState()) {
    loadLikes();
  }

  Future<void> loadLikes() async {
    try {
      final likedPosts = await _getLikedPostsUseCase.execute();
      emit(LikeState(likedPosts: likedPosts));
    } catch (e) {
    }
  }

  Future<void> toggleLike(int postId) async {
    try {
      await _toggleLikeUseCase.execute(postId);
      final likedPosts = await _getLikedPostsUseCase.execute();
      emit(LikeState(likedPosts: likedPosts));
    } catch (e) {
    }
  }

  bool isLiked(int postId) => state.isLiked(postId);
}
