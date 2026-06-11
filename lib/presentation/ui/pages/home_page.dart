import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinapp_material_ui/models/post_item_data.dart';
import 'package:pinapp_material_ui/ui/templates/home_template.dart';
import 'package:pinapp_test/presentation/blocs/like_cubit/like_cubit.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_event.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_state.dart';
import 'package:pinapp_test/presentation/ui/pages/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(const PostFetched());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        List<PostItemData> posts = [];
        bool isLoading = false;
        String? errorMessage;

        if (state is PostLoading) {
          isLoading = true;
        } else if (state is PostError) {
          errorMessage = state.message;
        } else if (state is PostLoaded) {
          posts = state.filteredPosts
              .map((p) => PostItemData(
                    id: p.id,
                    title: p.title,
                    body: p.body,
                    isLiked: p.isLiked,
                  ))
              .toList();
        }

        return HomeTemplate(
          searchController: _searchController,
          onSearchChanged: (query) {
            context.read<PostBloc>().add(PostSearched(query));
          },
          onSearchClear: () {
            context.read<PostBloc>().add(const PostSearched(''));
          },
          posts: posts,
          isLoading: isLoading,
          errorMessage: errorMessage,
          onLikeToggle: (postId) {
            if (state is PostLoaded) {
              final post = state.posts.firstWhere((p) => p.id == postId);
              context.read<PostBloc>().add(
                    PostLikeUpdated(
                      postId: postId,
                      isLiked: !post.isLiked,
                    ),
                  );
              context.read<LikeCubit>().toggleLike(postId);
            }
          },
          onPostTap: (postId, title, body) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  postId: postId,
                  title: title,
                  body: body,
                ),
              ),
            );
          },
          onRetry: () {
            context.read<PostBloc>().add(const PostFetched());
          },
          onRefresh: () {
            context.read<PostBloc>().add(const PostFetched());
          },
        );
      },
    );
  }
}
