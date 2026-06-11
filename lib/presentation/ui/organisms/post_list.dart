import 'package:flutter/material.dart';
import 'package:pinapp_test/presentation/blocs/like_cubit/like_cubit.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_event.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_state.dart';
import 'package:pinapp_test/presentation/ui/molecules/post_card.dart';
import 'package:pinapp_test/presentation/ui/pages/detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Organismo: Lista de posts
/// 
/// Muestra una lista scrollable de posts con manejo de estados
class PostList extends StatelessWidget {
  final VoidCallback? onPostTap;

  const PostList({
    super.key,
    this.onPostTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PostError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar posts',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PostBloc>().add(const PostFetched());
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is PostLoaded) {
          final posts = state.filteredPosts;
          
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No se encontraron posts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Intenta con otra búsqueda',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                id: post.id,
                title: post.title,
                body: post.body,
                isLiked: post.isLiked,
                onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      postId: post.id,
                      title: post.title,
                      body: post.body,
                    ),
                  ),
                );
              },
                onLikeTap: () {
                  context.read<PostBloc>().add(
                    PostLikeUpdated(
                      postId: post.id,
                      isLiked: !post.isLiked,
                    ),
                  );
                  context.read<LikeCubit>().toggleLike(post.id);
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
