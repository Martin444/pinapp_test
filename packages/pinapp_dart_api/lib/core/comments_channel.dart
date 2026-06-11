import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:pinapp_dart_api/core/api_constants.dart';

class CommentsPlatformChannel {
  static const MethodChannel _channel = MethodChannel(
    PlatformChannelConstants.channelName,
  );

  Future<List<dynamic>> getComments(int postId) async {
    final String result = await _channel.invokeMethod(
      PlatformChannelConstants.getCommentsMethod,
      {PlatformChannelConstants.postIdKey: postId},
    );
    return json.decode(result) as List<dynamic>;
  }
}
