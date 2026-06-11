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
  late MockGetPostsUseCase mockGetPostsUseCase;
  late MockToggleLikeUseCase mockToggleLikeUseCase;

  setUp(() {
    mockGetPostsUseCase = MockGetPostsUseCase();
    mockToggleLikeUseCase = MockToggleLikeUseCase();
  });

  group('PostFetched', () {
    blocTest<PostBloc, PostState>(
      'emite [PostLoading, PostLoaded] cuando es exitoso',
      build: () {
        when(() => mockGetPostsUseCase.execute()).thenAnswer(
          (_) async => [
            const PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1', isLiked: false),
          ],
        );
        return PostBloc(
          getPostsUseCase: mockGetPostsUseCase,
          toggleLikeUseCase: mockToggleLikeUseCase,
        );
      },
      act: (bloc) => bloc.add(const PostFetched()),
      expect: () => [isA<PostLoading>(), isA<PostLoaded>()],
    );

    blocTest<PostBloc, PostState>(
      'emite [PostLoading, PostError] cuando falla',
      build: () {
        when(() => mockGetPostsUseCase.execute()).thenThrow(Exception('Error'));
        return PostBloc(
          getPostsUseCase: mockGetPostsUseCase,
          toggleLikeUseCase: mockToggleLikeUseCase,
        );
      },
      act: (bloc) => bloc.add(const PostFetched()),
      expect: () => [isA<PostLoading>(), isA<PostError>()],
    );
  });

  group('PostSearched', () {
    blocTest<PostBloc, PostState>(
      'filtra posts por titulo',
      build: () {
        when(() => mockGetPostsUseCase.execute()).thenAnswer(
          (_) async => [
            const PostModel(id: 1, userId: 1, title: 'Flutter post', body: 'Body X', isLiked: false),
            const PostModel(id: 2, userId: 1, title: 'Dart post', body: 'Body Y', isLiked: false),
          ],
        );
        return PostBloc(
          getPostsUseCase: mockGetPostsUseCase,
          toggleLikeUseCase: mockToggleLikeUseCase,
        );
      },
      seed: () => PostLoaded(
        posts: [
          const PostModel(id: 1, userId: 1, title: 'Flutter post', body: 'Body X', isLiked: false),
          const PostModel(id: 2, userId: 1, title: 'Dart post', body: 'Body Y', isLiked: false),
        ],
        filteredPosts: [
          const PostModel(id: 1, userId: 1, title: 'Flutter post', body: 'Body X', isLiked: false),
          const PostModel(id: 2, userId: 1, title: 'Dart post', body: 'Body Y', isLiked: false),
        ],
      ),
      act: (bloc) => bloc.add(const PostSearched('flutter')),
      expect: () => [
        isA<PostLoaded>().having((s) => s.filteredPosts.length, 'filtered length', 1),
      ],
    );

    blocTest<PostBloc, PostState>(
      'filtra posts por body',
      build: () {
        return PostBloc(
          getPostsUseCase: mockGetPostsUseCase,
          toggleLikeUseCase: mockToggleLikeUseCase,
        );
      },
      seed: () => PostLoaded(
        posts: [
          const PostModel(id: 1, userId: 1, title: 'Title A', body: 'contenido importante', isLiked: false),
          const PostModel(id: 2, userId: 1, title: 'Title B', body: 'otra cosa', isLiked: false),
        ],
        filteredPosts: [
          const PostModel(id: 1, userId: 1, title: 'Title A', body: 'contenido importante', isLiked: false),
          const PostModel(id: 2, userId: 1, title: 'Title B', body: 'otra cosa', isLiked: false),
        ],
      ),
      act: (bloc) => bloc.add(const PostSearched('importante')),
      expect: () => [
        isA<PostLoaded>().having((s) => s.filteredPosts.length, 'filtered length', 1),
      ],
    );

    blocTest<PostBloc, PostState>(
      'query vacia restaura todos los posts',
      build: () {
        return PostBloc(
          getPostsUseCase: mockGetPostsUseCase,
          toggleLikeUseCase: mockToggleLikeUseCase,
        );
      },
      seed: () => PostLoaded(
        posts: [
          const PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1', isLiked: false),
          const PostModel(id: 2, userId: 1, title: 'Post 2', body: 'Body 2', isLiked: false),
        ],
        filteredPosts: [
          const PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1', isLiked: false),
        ],
        searchQuery: 'Body 1',
      ),
      act: (bloc) => bloc.add(const PostSearched('')),
      expect: () => [
        isA<PostLoaded>().having((s) => s.filteredPosts.length, 'filtered length', 2),
      ],
    );
  });

  group('PostLikeUpdated', () {
    blocTest<PostBloc, PostState>(
      'toggle like actualiza isLiked segun el retorno del use case',
      build: () {
        when(() => mockToggleLikeUseCase.execute(1)).thenAnswer((_) async => true);
        return PostBloc(
          getPostsUseCase: mockGetPostsUseCase,
          toggleLikeUseCase: mockToggleLikeUseCase,
        );
      },
      seed: () => PostLoaded(
        posts: [
          const PostModel(id: 1, userId: 1, title: 'Post', body: 'Body', isLiked: false),
        ],
        filteredPosts: [
          const PostModel(id: 1, userId: 1, title: 'Post', body: 'Body', isLiked: false),
        ],
      ),
      act: (bloc) => bloc.add(const PostLikeUpdated(postId: 1)),
      expect: () => [
        isA<PostLoaded>().having(
          (s) => s.posts.firstWhere((p) => p.id == 1).isLiked,
          'isLiked after toggle',
          true,
        ),
      ],
    );
  });
}
