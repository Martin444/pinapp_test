import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';

class MockPostRepository extends Mock implements PostRepository {}
class MockLikeRepository extends Mock implements LikeRepository {}

void main() {
  late GetPostsUseCase useCase;
  late MockPostRepository mockPostRepo;
  late MockLikeRepository mockLikeRepo;

  setUp(() {
    mockPostRepo = MockPostRepository();
    mockLikeRepo = MockLikeRepository();
    useCase = GetPostsUseCase(mockPostRepo, mockLikeRepo);
  });

  group('GetPostsUseCase', () {
    test('debe retornar lista de posts con isLiked basado en likedPosts', () async {
      final mockPosts = [
        const PostModel(id: 1, userId: 1, title: 'Post 1', body: 'Body 1'),
        const PostModel(id: 2, userId: 1, title: 'Post 2', body: 'Body 2'),
      ];

      when(() => mockPostRepo.getPosts()).thenAnswer((_) async => mockPosts);
      when(() => mockLikeRepo.getLikedPosts()).thenAnswer((_) async => {1});

      final result = await useCase.execute();

      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].isLiked, true);
      expect(result[1].id, 2);
      expect(result[1].isLiked, false);
    });

    test('debe lanzar exception cuando falla el repositorio de posts', () async {
      when(() => mockPostRepo.getPosts()).thenThrow(Exception('Network error'));
      when(() => mockLikeRepo.getLikedPosts()).thenAnswer((_) async => {});

      expect(() => useCase.execute(), throwsException);
    });
  });
}
