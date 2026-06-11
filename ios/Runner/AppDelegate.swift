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
    
    os_log(.info, log: log, "Setting up method channel: %{public}@", "com.pinapp.comments")
    channel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }
      if call.method == "getComments" {
        if let args = call.arguments as? [String: Any],
           let postId = args["postId"] as? Int {
          self.fetchComments(postId: postId, result: result)
        } else {
          result(FlutterError(
            code: "INVALID_ARGUMENT",
            message: "postId is required",
            details: nil
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
      os_log(.error, log: log, "Invalid URL for postId=%d", postId)
      result(FlutterError(
        code: "INVALID_URL",
        message: "Could not construct URL for postId \(postId)",
        details: nil
      ))
      return
    }
    
    let request = URLRequest(url: url, timeoutInterval: 5.0)
    os_log(.debug, log: log, "Requesting: %{public}@", url.absoluteString)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        os_log(.error, log: self.log, "Network error for postId=%d: %{public}@", postId, error.localizedDescription)
        result(FlutterError(
          code: "NETWORK_ERROR",
          message: error.localizedDescription,
          details: nil
        ))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        os_log(.error, log: self.log, "Invalid response type for postId=%d", postId)
        result(FlutterError(
          code: "INVALID_RESPONSE",
          message: "Response is not HTTP",
          details: nil
        ))
        return
      }
      
      guard (200...299).contains(httpResponse.statusCode) else {
        os_log(.error, log: self.log, "HTTP error %d for postId=%d", httpResponse.statusCode, postId)
        result(FlutterError(
          code: "HTTP_ERROR",
          message: "Response code: \(httpResponse.statusCode)",
          details: nil
        ))
        return
      }
      
      guard let data = data else {
        os_log(.error, log: self.log, "No data for postId=%d", postId)
        result(FlutterError(
          code: "NO_DATA",
          message: "No data received",
          details: nil
        ))
        return
      }
      
      if let jsonString = String(data: data, encoding: .utf8) {
        os_log(.info, log: self.log, "Success: %d chars for postId=%d", jsonString.count, postId)
        result(jsonString)
      } else {
        os_log(.error, log: self.log, "Parse error for postId=%d", postId)
        result(FlutterError(
          code: "PARSE_ERROR",
          message: "Could not parse response",
          details: nil
        ))
      }
    }
    
    task.resume()
  }
}
