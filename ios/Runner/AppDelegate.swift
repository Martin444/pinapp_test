import Flutter
import UIKit

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
    
    channel.setMethodCallHandler { (call, result) in
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
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId)") else {
      result(FlutterError(
        code: "INVALID_URL",
        message: "Could not construct URL for postId \(postId)",
        details: nil
      ))
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        result(FlutterError(
          code: "NETWORK_ERROR",
          message: error.localizedDescription,
          details: nil
        ))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        result(FlutterError(
          code: "INVALID_RESPONSE",
          message: "Response is not HTTP",
          details: nil
        ))
        return
      }
      
      guard (200...299).contains(httpResponse.statusCode) else {
        result(FlutterError(
          code: "HTTP_ERROR",
          message: "Response code: \(httpResponse.statusCode)",
          details: nil
        ))
        return
      }
      
      guard let data = data else {
        result(FlutterError(
          code: "NO_DATA",
          message: "No data received",
          details: nil
        ))
        return
      }
      
      if let jsonString = String(data: data, encoding: .utf8) {
        result(jsonString)
      } else {
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
