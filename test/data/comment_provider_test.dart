import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';

class MockCommentsPlatformChannel extends Mock implements CommentsPlatformChannel {}

void main() {
  late CommentProvider provider;
  late MockCommentsPlatformChannel mockChannel;

  setUp(() {
    mockChannel = MockCommentsPlatformChannel();
    provider = CommentProvider(channel: mockChannel);
  });

  group('CommentProvider', () {
    test('retorna lista de CommentModel cuando el channel responde', () async {
      final responseBody = json.encode([
        {
          'id': 1,
          'postId': 1,
          'name': 'John',
          'email': 'john@test.com',
          'body': 'Comment body',
        },
      ]);

      when(() => mockChannel.getComments(1)).thenAnswer(
        (_) async => json.decode(responseBody) as List<dynamic>,
      );

      final result = await provider.getComments(1);

      expect(result.length, 1);
      expect(result[0].id, 1);
      expect(result[0].name, 'John');
      expect(result[0].email, 'john@test.com');
      expect(result[0].body, 'Comment body');
    });

    test('lanza exception cuando el channel falla', () async {
      when(() => mockChannel.getComments(1)).thenThrow(Exception('Channel error'));

      expect(() => provider.getComments(1), throwsException);
    });
  });
}
