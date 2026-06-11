import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_bloc.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_event.dart';
import 'package:pinapp_test/presentation/blocs/post_bloc/post_state.dart';

class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}
class MockToggleLikeUseCase extends Mock implements ToggleLikeUseCase {}

void main() {
  late PostBloc postBloc;
  late MockGetPostsUseCase mockGetPostsUseCase;
  late MockToggleLikeUseCase mockToggleLikeUseCase;

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
    mockToggleLikeUseCase = MockToggleLikeUseCase();
    postBloc = PostBloc(
      getPostsUseCase: mockGetPostsUseCase,
      toggleLikeUseCase: mockToggleLikeUseCase,
    );
  });

  tearDown(() {
    postBloc.close();
  });

  group('PostBloc', () {
    final mockPosts = [
      const PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1', isLiked: false),
      const PostModel(id: 2, userId: 1, title: 'Post 2', body: 'Body 2', isLiked: true),
    ];

    blocTest<PostBloc, PostState>(
      'emite [PostLoading, PostLoaded] cuando PostFetched es exitoso',
      build: () {
        when(() => mockGetPostsUseCase.execute()).thenAnswer((_) async => mockPosts);
        return postBloc;
      },
      act: (bloc) => bloc.add(const PostFetched()),
      expect: () => [
        isA<PostLoading>(),
        isA<PostLoaded>(),
      ],
    );

    blocTest<PostBloc, PostState>(
      'emite [PostLoading, PostError] cuando PostFetched falla',
      build: () {
        when(() => mockGetPostsUseCase.execute()).thenThrow(Exception('Error'));
        return postBloc;
      },
      act: (bloc) => bloc.add(const PostFetched()),
      expect: () => [
        isA<PostLoading>(),
        isA<PostError>(),
      ],
    );
  });
}
