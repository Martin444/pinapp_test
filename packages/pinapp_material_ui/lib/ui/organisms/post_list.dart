import 'package:flutter/material.dart';
import 'package:pinapp_material_ui/models/post_item_data.dart';
import 'package:pinapp_material_ui/ui/molecules/post_card.dart';

class PostList extends StatelessWidget {
  final List<PostItemData> posts;
  final bool isLoading;
  final String? errorMessage;
  final void Function(int postId) onLikeToggle;
  final void Function(int postId, String title, String body) onPostTap;
  final VoidCallback onRetry;
  final VoidCallback? onRefresh;

  const PostList({
    super.key,
    required this.posts,
    this.isLoading = false,
    this.errorMessage,
    required this.onLikeToggle,
    required this.onPostTap,
    required this.onRetry,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
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
              errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

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

    final listView = ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(
          id: post.id,
          title: post.title,
          body: post.body,
          isLiked: post.isLiked,
          onTap: () => onPostTap(post.id, post.title, post.body),
          onLikeTap: () => onLikeToggle(post.id),
        );
      },
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async => onRefresh?.call(),
        child: listView,
      );
    }

    return listView;
  }
}
