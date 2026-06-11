import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:pinapp_dart_api/pinapp_dart_api.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late PostProvider provider;
  late MockHttpClient mockClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    provider = PostProvider(client: mockClient);
  });

  group('PostProvider', () {
    test('retorna lista de PostModel cuando la respuesta es 200', () async {
      final responseBody = json.encode([
        {'id': 1, 'userId': 1, 'title': 'Titulo', 'body': 'Cuerpo'},
      ]);

      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response(responseBody, 200),
      );

      final result = await provider.getPosts();

      expect(result.length, 1);
      expect(result[0].id, 1);
      expect(result[0].title, 'Titulo');
      expect(result[0].body, 'Cuerpo');
    });

    test('lanza exception cuando la respuesta no es 200', () async {
      when(() => mockClient.get(any())).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(() => provider.getPosts(), throwsException);
    });

    test('lanza exception cuando falla la conexion', () async {
      when(() => mockClient.get(any())).thenThrow(Exception('Network error'));

      expect(() => provider.getPosts(), throwsException);
    });
  });
}
