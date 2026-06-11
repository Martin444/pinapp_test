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
    let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(postId)")!
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        result(FlutterError(
          code: "NETWORK_ERROR",
          message: error.localizedDescription,
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
