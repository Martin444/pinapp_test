# Platform Channels

> [[03-atomic-design|← Atomic Design]] | [[docs/README|Índice]] | [[05-testing|Siguiente: Testing →]]

## Overview

Los comentarios de cada post se obtienen desde código nativo usando Flutter Platform Channels. Esta implementación es un requisito clave del desafío técnico.

El bridge está definido en `packages/pinapp_dart_api/lib/core/comments_channel.dart`.

## Channel Configuration

```
Channel Name: com.pinapp.comments
Method: getComments
Arguments: {"postId": int}
Return: List<Map<String, dynamic>> (JSON string)
```

## Implementación en el Package

```dart
// packages/pinapp_dart_api/lib/core/comments_channel.dart
class CommentsPlatformChannel {
  static const _channel = MethodChannel('com.pinapp.comments');

  Future<List<dynamic>> getComments(int postId) async {
    final result = await _channel.invokeMethod('getComments', {
      'postId': postId,
    });
    return json.decode(result as String) as List<dynamic>;
  }
}
```

Usado por `CommentProvider` dentro del mismo package.

## Implementación iOS (Swift)

Archivo: `ios/Runner/AppDelegate.swift`

```swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "com.pinapp.comments",
      binaryMessenger: controller.binaryMessenger
    )
    
    channel.setMethodCallHandler { (call, result) in
      if call.method == "getComments" {
        if let args = call.arguments as? [String: Any],
           let postId = args["postId"] as? Int {
          self.fetchComments(postId: postId, result: result)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: nil, details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func fetchComments(postId: Int, result: @escaping FlutterResult) {
    let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId)")!
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        result(FlutterError(code: "NETWORK_ERROR", message: error.localizedDescription, details: nil))
        return
      }
      guard let data = data else {
        result(FlutterError(code: "NO_DATA", message: nil, details: nil))
        return
      }
      if let jsonString = String(data: data, encoding: .utf8) {
        result(jsonString)
      } else {
        result(FlutterError(code: "PARSE_ERROR", message: nil, details: nil))
      }
    }
    task.resume()
  }
}
```

## Implementación Android (Kotlin)

Archivo: `android/app/src/main/kotlin/com/test/pinapp/pinapp_test/MainActivity.kt`

```kotlin
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.Executors

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.pinapp.comments"
  private val executor = Executors.newSingleThreadExecutor()
  
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "getComments") {
        val postId = call.argument<Int>("postId")
        if (postId != null) {
          fetchComments(postId, result)
        } else {
          result.error("INVALID_ARGUMENT", "postId is required", null)
        }
      } else {
        result.notImplemented()
      }
    }
  }
  
  private fun fetchComments(postId: Int, result: MethodChannel.Result) {
    executor.execute {
      try {
        val url = URL("https://jsonplaceholder.typicode.com/comments?postId=$postId")
        val connection = url.openConnection() as HttpURLConnection
        connection.requestMethod = "GET"
        connection.connectTimeout = 5000
        connection.readTimeout = 5000
        
        val responseCode = connection.responseCode
        if (responseCode == HttpURLConnection.HTTP_OK) {
          val response = connection.inputStream.bufferedReader().use { it.readText() }
          result.success(response)
        } else {
          result.error("HTTP_ERROR", "Response code: $responseCode", null)
        }
        connection.disconnect()
      } catch (e: Exception) {
        result.error("NETWORK_ERROR", e.message, null)
      }
    }
  }
}
```

## Diagrama de Flujo

```
Flutter App (root)
  → PostBloc.add(CommentFetched(postId))
  → GetCommentsUseCase.execute(postId)
  → CommentProvider.getComments(postId)
  → CommentsPlatformChannel.getComments(postId)
  → MethodChannel.invokeMethod('getComments', {'postId': 1})
  → iOS/Android recibe la llamada
  → Nativo hace HTTP a jsonplaceholder
  → Nativo recibe JSON
  → Nativo devuelve JSON como String
  → Flutter recibe String y hace json.decode
  → Flutter mapea a CommentModel
  → PostBloc emite CommentLoaded(comments)
  → UI renderiza CommentTile list
```

## Manejo de Errores

Todos los errores se manejan con try-catch y se devuelven como FlutterError/result.error.

---

## Referencias

- [[02-architecture|Arquitectura]]
- [[03-atomic-design|Atomic Design]]
- [[05-testing|Testing]]
- [[01-setup|Setup del Proyecto]]
