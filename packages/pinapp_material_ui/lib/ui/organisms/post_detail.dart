import 'package:flutter/material.dart';
import 'package:pinapp_material_ui/models/comment_item_data.dart';
import 'package:pinapp_material_ui/ui/molecules/comment_tile.dart';

class PostDetail extends StatelessWidget {
  final String title;
  final String body;
  final bool isLiked;
  final VoidCallback? onLikeTap;
  final List<CommentItemData> comments;
  final bool commentsLoading;
  final String? commentsError;

  const PostDetail({
    super.key,
    required this.title,
    required this.body,
    this.isLiked = false,
    this.onLikeTap,
    this.comments = const [],
    this.commentsLoading = false,
    this.commentsError,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildPostHeader(context),
        ),
        SliverToBoxAdapter(
          child: _buildCommentsHeader(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: _buildCommentsList(context),
        ),
      ],
    );
  }

  Widget _buildPostHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                ),
                onPressed: onLikeTap,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 24),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.comment,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Comentarios',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList(BuildContext context) {
    if (commentsLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (commentsError != null) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar comentarios',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  commentsError!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (comments.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text('No hay comentarios'),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final comment = comments[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CommentTile(
              name: comment.name,
              email: comment.email,
              body: comment.body,
            ),
          );
        },
        childCount: comments.length,
      ),
    );
  }
}
