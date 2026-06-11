package com.test.pinapp.pinapp_test

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.ConnectException
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
    
    MethodChannel(
      flutterEngine.dartExecutor.binaryMessenger,
      CHANNEL
    ).setMethodCallHandler { call, result ->
      when (call.method) {
        "getComments" -> {
          val postId = call.argument<Int>("postId")
          val apiBaseUrl = call.argument<String>("apiBaseUrl")
              ?: API_BASE_URL
          if (postId != null) {
            fetchComments(postId, apiBaseUrl, result)
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
  
  private fun fetchComments(postId: Int, apiBaseUrl: String, result: MethodChannel.Result) {
    Log.d(TAG, "Fetching comments for postId=$postId baseUrl=$apiBaseUrl")
    executor.execute {
      try {
        val url = URL("$apiBaseUrl/comments?postId=$postId")
        Log.d(TAG, "Requesting: $url")
        val connection = url.openConnection() as HttpURLConnection
        
        connection.apply {
          requestMethod = "GET"
          connectTimeout = 5000
          readTimeout = 5000
          setRequestProperty("Accept", "application/json")
        }
        
        val responseCode = connection.responseCode
        Log.d(TAG, "Response code: $responseCode")
        
        if (!isActivityAlive.get()) {
          Log.w(TAG, "Activity destroyed, dropping response")
          return@execute
        }
        
        if (responseCode == HttpURLConnection.HTTP_OK) {
          val response = connection.inputStream.bufferedReader().use { it.readText() }
          if (response.isBlank()) {
            Log.w(TAG, "Empty response body for postId=$postId")
            result.error("NO_DATA", "Empty response received", null)
            return@execute
          }
          Log.d(TAG, "Success: ${response.length} chars for postId=$postId")
          result.success(response)
        } else {
          Log.e(TAG, "HTTP error $responseCode for postId=$postId")
          result.error(
            "HTTP_ERROR",
            "Response code: $responseCode",
            null
          )
        }
        
        connection.disconnect()
      } catch (e: MalformedURLException) {
        Log.e(TAG, "Malformed URL for postId=$postId: ${e.message}")
        if (!isActivityAlive.get()) return@execute
        result.error("INVALID_ARGUMENT", "Malformed URL: ${e.message}", null)
      } catch (e: SocketTimeoutException) {
        Log.e(TAG, "Timeout for postId=$postId: ${e.message}")
        if (!isActivityAlive.get()) return@execute
        result.error("TIMEOUT_ERROR", "Request timed out: ${e.message}", null)
      } catch (e: UnknownHostException) {
        Log.e(TAG, "No internet for postId=$postId: ${e.message}")
        if (!isActivityAlive.get()) return@execute
        result.error("NETWORK_ERROR", "No internet connection: ${e.message}", null)
      } catch (e: Exception) {
        Log.e(TAG, "Network error for postId=$postId: ${e.message}")
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
