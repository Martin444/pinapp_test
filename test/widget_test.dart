import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_event.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_state.dart';
import 'package:pinapp_test/presentation/ui/pages/home_page.dart';

class MockPostBloc extends MockBloc<PostEvent, PostState> implements PostBloc {}
class MockGetCommentsUseCase extends Mock implements GetCommentsUseCase {}

void main() {
  late MockPostBloc mockPostBloc;

  setUp(() {
    mockPostBloc = MockPostBloc();
  });

  testWidgets('HomePage muestra loading cuando PostState es PostLoading', (tester) async {
    whenListen(
      mockPostBloc,
      Stream.fromIterable([const PostLoading()]),
      initialState: const PostInitial(),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PostBloc>.value(value: mockPostBloc),
          BlocProvider<CommentBloc>(
            create: (_) => CommentBloc(
              getCommentsUseCase: MockGetCommentsUseCase(),
            ),
          ),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
