import 'package:equatable/equatable.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {
  const PostInitial();
}

class PostLoading extends PostState {
  const PostLoading();
}

class PostLoaded extends PostState {
  final List<PostModel> posts;
  final List<PostModel> filteredPosts;
  final String searchQuery;

  const PostLoaded({
    required this.posts,
    this.filteredPosts = const [],
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [posts, filteredPosts, searchQuery];

  PostLoaded copyWith({
    List<PostModel>? posts,
    List<PostModel>? filteredPosts,
    String? searchQuery,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      filteredPosts: filteredPosts ?? this.filteredPosts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class PostError extends PostState {
  final String message;

  const PostError(this.message);

  @override
  List<Object?> get props => [message];
}
