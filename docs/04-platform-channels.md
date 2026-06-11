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
    try {
      final result = await _channel.invokeMethod('getComments', {
        'postId': postId,
      });
      return json.decode(result as String) as List<dynamic>;
    } on MissingPluginException {
      throw Exception('Platform channel not implemented');
    } on FormatException catch (e) {
      throw Exception('Invalid JSON response from native: $e');
    } on TypeError catch (e) {
      throw Exception('Unexpected type from native channel: $e');
    }
  }
}
```

Usado por `CommentProvider` dentro del mismo package.

## Implementación iOS (Swift)

Archivo: `ios/Runner/AppDelegate.swift`

```swift
import Flutter
import UIKit
import os.log

private let API_BASE_URL = "https://jsonplaceholder.typicode.com"
private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.pinapp", category: "Comments")

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      fatalError("rootViewController is not FlutterViewController")
    }
    let channel = FlutterMethodChannel(
      name: "com.pinapp.comments",
      binaryMessenger: controller.binaryMessenger
    )
    
    os_log(.info, log: log, "Setting up method channel")
    channel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      if call.method == "getComments" {
        if let args = call.arguments as? [String: Any],
           let postId = args["postId"] as? Int {
          self.fetchComments(postId: postId, result: result)
        } else {
          result(FlutterError(
            code: "INVALID_ARGUMENT", message: "postId is required", details: nil
          ))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func fetchComments(postId: Int, result: @escaping FlutterResult) {
    os_log(.info, log: log, "Fetching comments for postId=%d", postId)
    guard let url = URL(string: "\(API_BASE_URL)/comments?postId=\(postId)") else {
      result(FlutterError(code: "INVALID_URL", message: nil, details: nil))
      return
    }
    
    let request = URLRequest(url: url, timeoutInterval: 5.0)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        result(FlutterError(code: "NETWORK_ERROR", message: error.localizedDescription, details: nil))
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
        result(FlutterError(code: "HTTP_ERROR", message: nil, details: nil))
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
package com.test.pinapp.pinapp_test

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.HttpURLConnection
import java.net.MalformedURLException
import java.net.SocketTimeoutException
import java.net.URL
import java.net.UnknownHostException
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

private const val API_BASE_URL = "https://jsonplaceholder.typicode.com"

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.pinapp.comments"
  private val TAG = "PinAppComments"
  private val executor = Executors.newSingleThreadExecutor()
  private val isActivityAlive = AtomicBoolean(true)
  
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      when (call.method) {
        "getComments" -> {
          val postId = call.argument<Int>("postId")
          if (postId != null) {
            fetchComments(postId, result)
          } else {
            result.error("INVALID_ARGUMENT", "postId is required", null)
          }
        }
        else -> result.notImplemented()
      }
    }
  }
  
  private fun fetchComments(postId: Int, result: MethodChannel.Result) {
    Log.d(TAG, "Fetching comments for postId=$postId")
    executor.execute {
      try {
        val url = URL("$API_BASE_URL/comments?postId=$postId")
        val connection = url.openConnection() as HttpURLConnection
        connection.requestMethod = "GET"
        connection.connectTimeout = 5000
        connection.readTimeout = 5000
        connection.setRequestProperty("Accept", "application/json")
        
        val responseCode = connection.responseCode
        Log.d(TAG, "Response code: $responseCode")
        
        if (!isActivityAlive.get()) return@execute
        if (responseCode == HttpURLConnection.HTTP_OK) {
          val response = connection.inputStream.bufferedReader().use { it.readText() }
          if (response.isBlank()) {
            result.error("NO_DATA", "Empty response received", null)
            return@execute
          }
          result.success(response)
        } else {
          result.error("HTTP_ERROR", "Response code: $responseCode", null)
        }
        connection.disconnect()
      } catch (e: MalformedURLException) {
        if (!isActivityAlive.get()) return@execute
        result.error("INVALID_ARGUMENT", "Malformed URL: ${e.message}", null)
      } catch (e: SocketTimeoutException) {
        if (!isActivityAlive.get()) return@execute
        result.error("TIMEOUT_ERROR", "Request timed out: ${e.message}", null)
      } catch (e: UnknownHostException) {
        if (!isActivityAlive.get()) return@execute
        result.error("NETWORK_ERROR", "No internet connection: ${e.message}", null)
      } catch (e: Exception) {
        if (!isActivityAlive.get()) return@execute
        result.error("NETWORK_ERROR", e.message, null)
      }
    }
  }
  
  override fun onDestroy() {
    super.onDestroy()
    isActivityAlive.set(false)
    executor.shutdownNow()
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

## Códigos de Error

| Código | Android | iOS | Causa |
|--------|---------|-----|-------|
| `INVALID_ARGUMENT` | ✅ | ✅ | `postId` ausente o URL mal formada |
| `HTTP_ERROR` | ✅ | ✅ | Status code HTTP fuera de 200-299 |
| `NETWORK_ERROR` | ✅ | ✅ | Sin internet o error de red genérico |
| `TIMEOUT_ERROR` | ✅ | ❌ | Timeout de conexión/lectura (5s) |
| `NO_DATA` | ✅ | ✅ | Respuesta vacía |
| `PARSE_ERROR` | ❌ | ✅ | Fallo al decodificar UTF-8 (solo iOS) |
| `INVALID_URL` | ❌ | ✅ | URL mal construida (solo iOS) |
| `INVALID_RESPONSE` | ❌ | ✅ | Response no es HTTP (solo iOS) |

Todos los errores se devuelven como `FlutterError`/`result.error` con mensaje descriptivo y logging nativo (`Log.d` / `os_log`).

---

## Referencias

- [[02-architecture|Arquitectura]]
- [[03-atomic-design|Atomic Design]]
- [[05-testing|Testing]]
- [[01-setup|Setup del Proyecto]]
