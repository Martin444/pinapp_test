import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinapp_dart_api/core/api_constants.dart';
import 'package:pinapp_dart_api/by_feature/likes/data/repository/like_repository.dart';

class LikeProvider extends LikeRepository {
  final SharedPreferences? _prefs;

  LikeProvider({SharedPreferences? prefs}) : _prefs = prefs;

  Future<SharedPreferences> _getPrefs() async {
    if (_prefs != null) return _prefs;
    return await SharedPreferences.getInstance();
  }

  @override
  Future<Set<int>> getLikedPosts() async {
    final prefs = await _getPrefs();
    final String? jsonString = prefs.getString(SharedPreferencesConstants.likesKey);

    if (jsonString == null || jsonString.isEmpty) {
      return <int>{};
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((id) => id as int).toSet();
    } catch (e) {
      return <int>{};
    }
  }

  @override
  Future<bool> toggleLike(int postId) async {
    final prefs = await _getPrefs();
    final likedPosts = await getLikedPosts();

    final bool isLiked = likedPosts.contains(postId);

    if (isLiked) {
      likedPosts.remove(postId);
    } else {
      likedPosts.add(postId);
    }

    await prefs.setString(
      SharedPreferencesConstants.likesKey,
      json.encode(likedPosts.toList()),
    );

    return !isLiked;
  }

  @override
  Future<bool> isLiked(int postId) async {
    final likedPosts = await getLikedPosts();
    return likedPosts.contains(postId);
  }
}
