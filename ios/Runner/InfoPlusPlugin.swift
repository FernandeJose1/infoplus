import Flutter
import UIKit

public class InfoPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "infoplus/ussd", binaryMessenger: registrar.messenger())
    let instance = InfoPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "sendUssd" {
      guard let args = call.arguments as? [String: Any], let code = args["code"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing USSD code", details: nil))
        return
      }
      sendUssd(code: code, result: result)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  private func sendUssd(code: String, result: @escaping FlutterResult) {
    let ussd = code.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? code
    if let url = URL(string: "tel://