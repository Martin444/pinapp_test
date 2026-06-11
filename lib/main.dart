import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';
import 'package:pinapp_test/core/theme/app_theme.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_bloc.dart';
import 'package:pinapp_test/presentation/blocs/like_cubit/like_cubit.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_bloc.dart';
import 'package:pinapp_test/presentation/ui/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final postRepository = PostProvider();
    final commentRepository = CommentProvider();
    final likeRepository = LikeProvider();

    final getPostsUseCase = GetPostsUseCase(postRepository, likeRepository);
    final getCommentsUseCase = GetCommentsUseCase(commentRepository);
    final getLikedPostsUseCase = GetLikedPostsUseCase(likeRepository);
    final toggleLikeUseCase = ToggleLikeUseCase(likeRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(
          create: (context) => PostBloc(
            getPostsUseCase: getPostsUseCase,
            toggleLikeUseCase: toggleLikeUseCase,
          ),
        ),
        BlocProvider<CommentBloc>(
          create: (context) => CommentBloc(
            getCommentsUseCase: getCommentsUseCase,
          ),
        ),
        BlocProvider<LikeCubit>(
          create: (context) => LikeCubit(
            getLikedPostsUseCase: getLikedPostsUseCase,
            toggleLikeUseCase: toggleLikeUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'PinApp Posts',
        debugShowCheckedModeBanner: false,
        theme: PinAppTheme.theme,
        home: const HomePage(),
      ),
    );
  }
}
