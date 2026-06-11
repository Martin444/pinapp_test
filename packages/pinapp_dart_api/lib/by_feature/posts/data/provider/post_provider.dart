import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pinapp_dart_api/core/api_constants.dart';
import 'package:pinapp_dart_api/by_feature/posts/models/post_model.dart';
import 'package:pinapp_dart_api/by_feature/posts/data/repository/post_repository.dart';

class PostProvider extends PostRepository {
  final http.Client _client;

  PostProvider({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.postsEndpoint}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Error HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener posts: $e');
    }
  }
}
