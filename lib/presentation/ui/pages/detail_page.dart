import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinapp_material_ui/models/comment_item_data.dart';
import 'package:pinapp_material_ui/ui/templates/detail_template.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_bloc.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_event.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_state.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_event.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_state.dart';

class DetailPage extends StatefulWidget {
  final int postId;
  final String title;
  final String body;

  const DetailPage({
    super.key,
    required this.postId,
    required this.title,
    required this.body,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(
      CommentFetched(postId: widget.postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, postState) {
        if (postState is! PostLoaded) {
          return const Scaffold(
            appBar: null,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final post = postState.posts.firstWhere(
          (p) => p.id == widget.postId,
          orElse: () => postState.posts.first,
        );
        final isLiked = post.isLiked;

        return BlocBuilder<CommentBloc, CommentState>(
          builder: (context, commentState) {
            List<CommentItemData> comments = [];
            bool commentsLoading = false;
            String? commentsError;

            if (commentState is CommentLoading) {
              commentsLoading = true;
            } else if (commentState is CommentError) {
              commentsError = commentState.message;
            } else if (commentState is CommentLoaded) {
              comments = commentState.comments
                  .map((c) => CommentItemData(
                        name: c.name,
                        email: c.email,
                        body: c.body,
                      ))
                  .toList();
            }

            return DetailTemplate(
              title: widget.title,
              body: widget.body,
              isLiked: isLiked,
              onLikeTap: () {
                context.read<PostBloc>().add(
                      PostLikeUpdated(postId: widget.postId),
                    );
              },
              onBackTap: () => Navigator.of(context).pop(),
              comments: comments,
              commentsLoading: commentsLoading,
              commentsError: commentsError,
            );
          },
        );
      },
    );
  }
}
