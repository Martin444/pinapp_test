import 'package:flutter/material.dart';
import 'package:pinapp_material_ui/models/comment_item_data.dart';
import 'package:pinapp_material_ui/ui/organisms/post_detail.dart';

class DetailTemplate extends StatelessWidget {
  final String title;
  final String body;
  final bool isLiked;
  final VoidCallback? onLikeTap;
  final VoidCallback? onBackTap;
  final List<CommentItemData> comments;
  final bool commentsLoading;
  final String? commentsError;

  const DetailTemplate({
    super.key,
    required this.title,
    required this.body,
    this.isLiked = false,
    this.onLikeTap,
    this.onBackTap,
    this.comments = const [],
    this.commentsLoading = false,
    this.commentsError,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackTap ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: PostDetail(
        title: title,
        body: body,
        isLiked: isLiked,
        onLikeTap: onLikeTap,
        comments: comments,
        commentsLoading: commentsLoading,
        commentsError: commentsError,
      ),
    );
  }
}
