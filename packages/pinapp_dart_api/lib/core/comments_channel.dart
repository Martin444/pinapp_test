import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pinapp_dart_api/core/api_constants.dart';

class CommentsPlatformChannel {
  static const MethodChannel _channel = MethodChannel(
    PlatformChannelConstants.channelName,
  );

  Future<List<dynamic>> getComments(int postId) async {
    try {
      final String result = await _channel.invokeMethod(
        PlatformChannelConstants.getCommentsMethod,
        {PlatformChannelConstants.postIdKey: postId},
      );
      return json.decode(result) as List<dynamic>;
    } on MissingPluginException {
      throw Exception(
        'Platform channel not implemented: ${PlatformChannelConstants.channelName}',
      );
    } on FormatException catch (e) {
      throw Exception('Invalid JSON response from native: $e');
    } on TypeError catch (e) {
      throw Exception('Unexpected type from native channel: $e');
    }
  }
}
