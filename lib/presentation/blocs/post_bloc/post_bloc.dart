import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_event.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase _getPostsUseCase;
  final ToggleLikeUseCase _toggleLikeUseCase;

  PostBloc({
    required GetPostsUseCase getPostsUseCase,
    required ToggleLikeUseCase toggleLikeUseCase,
  })  : _getPostsUseCase = getPostsUseCase,
        _toggleLikeUseCase = toggleLikeUseCase,
        super(const PostInitial()) {
    on<PostFetched>(_onPostFetched);
    on<PostSearched>(_onPostSearched);
    on<PostLikeUpdated>(_onPostLikeUpdated);
  }

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    emit(const PostLoading());
    try {
      final posts = await _getPostsUseCase.execute();
      emit(PostLoaded(
        posts: posts,
        filteredPosts: posts,
      ));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  void _onPostSearched(
    PostSearched event,
    Emitter<PostState> emit,
  ) {
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;
      final query = event.query.toLowerCase();

      final filteredPosts = currentState.posts.where((post) {
        return post.title.toLowerCase().contains(query) ||
            post.body.toLowerCase().contains(query);
      }).toList();

      emit(currentState.copyWith(
        filteredPosts: filteredPosts,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _onPostLikeUpdated(
    PostLikeUpdated event,
    Emitter<PostState> emit,
  ) async {
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;

      final isLiked = await _toggleLikeUseCase.execute(event.postId);

      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(isLiked: isLiked);
        }
        return post;
      }).toList();

      final updatedFilteredPosts = currentState.filteredPosts.map((post) {
        if (post.id == event.postId) {
          return post.copyWith(isLiked: isLiked);
        }
        return post;
      }).toList();

      emit(currentState.copyWith(
        posts: updatedPosts,
        filteredPosts: updatedFilteredPosts,
      ));
    }
  }
}
