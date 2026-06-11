import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_bloc.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_event.dart';
import 'package:pinapp_test/presentation/blocs/comment_bloc/comment_state.dart';

class MockGetCommentsUseCase extends Mock implements GetCommentsUseCase {}

void main() {
  late CommentBloc commentBloc;
  late MockGetCommentsUseCase mockGetCommentsUseCase;

  setUp(() {
    mockGetCommentsUseCase = MockGetCommentsUseCase();
    commentBloc = CommentBloc(
      getCommentsUseCase: mockGetCommentsUseCase,
    );
  });

  tearDown(() {
    commentBloc.close();
  });

  group('CommentBloc', () {
    blocTest<CommentBloc, CommentState>(
      'emite [CommentLoading, CommentLoaded] cuando CommentFetched es exitoso',
      build: () {
        when(() => mockGetCommentsUseCase.execute(1)).thenAnswer(
          (_) async => [
            const CommentModel(
              id: 1,
              postId: 1,
              name: 'John',
              email: 'john@test.com',
              body: 'Comment',
            ),
          ],
        );
        return commentBloc;
      },
      act: (bloc) => bloc.add(const CommentFetched(postId: 1)),
      expect: () => [
        isA<CommentLoading>(),
        isA<CommentLoaded>(),
      ],
    );

    blocTest<CommentBloc, CommentState>(
      'emite [CommentLoading, CommentError] cuando CommentFetched falla',
      build: () {
        when(() => mockGetCommentsUseCase.execute(1)).thenThrow(Exception('Error'));
        return commentBloc;
      },
      act: (bloc) => bloc.add(const CommentFetched(postId: 1)),
      expect: () => [
        isA<CommentLoading>(),
        isA<CommentError>(),
      ],
    );
  });
}
