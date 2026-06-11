package com.test.pinapp.pinapp_test

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.pinapp.comments"
  private val executor = Executors.newSingleThreadExecutor()
  private val isActivityAlive = AtomicBoolean(true)
  
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    
    MethodChannel(
      flutterEngine.dartExecutor.binaryMessenger,
      CHANNEL
    ).setMethodCallHandler { call, result ->
      when (call.method) {
        "getComments" -> {
          val postId = call.argument<Int>("postId")
          if (postId != null) {
            fetchComments(postId, result)
          } else {
            result.error(
              "INVALID_ARGUMENT",
              "postId is required",
              null
            )
          }
        }
        else -> result.notImplemented()
      }
    }
  }
  
  private fun fetchComments(postId: Int, result: MethodChannel.Result) {
    executor.execute {
      try {
        val url = URL("https://jsonplaceholder.typicode.com/comments?postId=$postId")
        val connection = url.openConnection() as HttpURLConnection
        
        connection.apply {
          requestMethod = "GET"
          connectTimeout = 5000
          readTimeout = 5000
          setRequestProperty("Accept", "application/json")
        }
        
        val responseCode = connection.responseCode
        
        if (!isActivityAlive.get()) return@execute
        
        if (responseCode == HttpURLConnection.HTTP_OK) {
          val response = connection.inputStream.bufferedReader().use { it.readText() }
          result.success(response)
        } else {
          result.error(
            "HTTP_ERROR",
            "Response code: $responseCode",
            null
          )
        }
        
        connection.disconnect()
      } catch (e: Exception) {
        if (!isActivityAlive.get()) return@execute
        result.error(
          "NETWORK_ERROR",
          e.message ?: "Unknown error",
          null
        )
      }
    }
  }
  
  override fun onDestroy() {
    super.onDestroy()
    isActivityAlive.set(false)
    executor.shutdownNow()
  }
}
