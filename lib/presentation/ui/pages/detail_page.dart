import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_bloc.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_event.dart';
import 'package:pinapp_test/presentation/blocs/like_cubit/like_cubit.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_event.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_state.dart';
import 'package:pinapp_test/presentation/ui/templates/detail_template.dart';

/// Página: Detalle
/// 
/// Pantalla completa de detalle de un post
/// Usa DetailTemplate y conecta con los BLoCs
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
        bool isLiked = false;
        
        if (postState is PostLoaded) {
          final post = postState.posts.firstWhere(
            (p) => p.id == widget.postId,
            orElse: () => postState.posts.first,
          );
          isLiked = post.isLiked;
        }

        return DetailTemplate(
          title: widget.title,
          body: widget.body,
          isLiked: isLiked,
          onLikeTap: () {
            context.read<PostBloc>().add(
              PostLikeUpdated(
                postId: widget.postId,
                isLiked: !isLiked,
              ),
            );
            context.read<LikeCubit>().toggleLike(widget.postId);
          },
          onBackTap: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
