import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_bloc.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_event.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_state.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_event.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_state.dart';
import 'package:pinapp_test/presentation/ui/pages/detail_page.dart';

class MockPostBloc extends MockBloc<PostEvent, PostState> implements PostBloc {}
class MockCommentBloc extends MockBloc<CommentEvent, CommentState> implements CommentBloc {}

void main() {
  late MockPostBloc mockPostBloc;
  late MockCommentBloc mockCommentBloc;

  setUp(() {
    mockPostBloc = MockPostBloc();
    mockCommentBloc = MockCommentBloc();
  });

  testWidgets('DetailPage muestra loading cuando PostState no es PostLoaded', (tester) async {
    whenListen(
      mockPostBloc,
      Stream.fromIterable([const PostInitial()]),
      initialState: const PostInitial(),
    );
    whenListen(
      mockCommentBloc,
      Stream.fromIterable([const CommentInitial()]),
      initialState: const CommentInitial(),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>.value(value: mockPostBloc),
          BlocProvider<CommentBloc>.value(value: mockCommentBloc),
        ],
        child: const MaterialApp(
          home: DetailPage(postId: 1, title: 'Titulo', body: 'Cuerpo'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DetailPage muestra titulo, body y comentarios cuando esta cargado', (tester) async {
    whenListen(
      mockPostBloc,
      Stream.fromIterable([
        PostLoaded(
          posts: [
            PostModel(id: 1, userId: 1, title: 'Titulo', body: 'Cuerpo', isLiked: true),
          ],
          filteredPosts: [],
        ),
      ]),
      initialState: const PostInitial(),
    );
    whenListen(
      mockCommentBloc,
      Stream.fromIterable([
        CommentLoaded(
          comments: [
            const CommentModel(id: 1, postId: 1, name: 'John', email: 'john@test.com', body: 'Comment'),
          ],
        ),
      ]),
      initialState: const CommentInitial(),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>.value(value: mockPostBloc),
          BlocProvider<CommentBloc>.value(value: mockCommentBloc),
        ],
        child: const MaterialApp(
          home: DetailPage(postId: 1, title: 'Titulo', body: 'Cuerpo'),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('Titulo'), findsOneWidget);
    expect(find.text('Cuerpo'), findsOneWidget);
    expect(find.text('Comentarios'), findsOneWidget);
    expect(find.text('John'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
