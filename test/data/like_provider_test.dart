import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';

void main() {
  group('LikeProvider', () {
    test('getLikedPosts retorna set vacio cuando no hay datos', () async {
      SharedPreferences.setMockInitialValues({});

      final provider = LikeProvider();
      final result = await provider.getLikedPosts();

      expect(result, <int>{});
    });

    test('toggleLike agrega un post y retorna true', () async {
      SharedPreferences.setMockInitialValues({});

      final provider = LikeProvider();
      final result = await provider.toggleLike(1);

      expect(result, true);
      final liked = await provider.getLikedPosts();
      expect(liked, {1});
    });

    test('toggleLike remueve un post y retorna false', () async {
      SharedPreferences.setMockInitialValues({
        'likes': '[1]',
      });

      final provider = LikeProvider();
      final result = await provider.toggleLike(1);

      expect(result, false);
      final liked = await provider.getLikedPosts();
      expect(liked, <int>{});
    });

    test('isLiked retorna true si el post esta en la lista', () async {
      SharedPreferences.setMockInitialValues({
        'likes': '[1, 2, 3]',
      });

      final provider = LikeProvider();
      final result = await provider.isLiked(2);

      expect(result, true);
    });

    test('isLiked retorna false si el post no esta en la lista', () async {
      SharedPreferences.setMockInitialValues({
        'likes': '[1, 2, 3]',
      });

      final provider = LikeProvider();
      final result = await provider.isLiked(5);

      expect(result, false);
    });
  });
}
