import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pinapp_dart_api/pinapp_dart_api.dart';
import 'package:pinapp_material_ui/pinapp_material_ui.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_bloc.dart';
import 'package:pinapp_test/presentation/ui/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _httpClient = http.Client();

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postRepository = PostProvider(client: _httpClient);
    final commentRepository = CommentProvider();
    final likeRepository = LikeProvider();

    final getPostsUseCase = GetPostsUseCase(postRepository, likeRepository);
    final getCommentsUseCase = GetCommentsUseCase(commentRepository);
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
