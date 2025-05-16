import UIKit
import Flutter
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let channelName = "com.ussd.infoplus/payment"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let ussdChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

        ussdChannel.setMethodCallHandler { (call, result) in
            if call.method == "sendUssd" {
                guard let args = call.arguments as? [String: Any],
                      let code = args["code"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Código USSD não informado", details: nil))
                    return
                }
                self.sendUssd(code: code, result: result)
            } else if call.method == "startPayment" {
                // Você pode implementar se quiser ações específicas para pagamentos
                result("startPayment não implementado no iOS")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func sendUssd(code: String, result: FlutterResult) {
        // iOS não permite discagem USSD automática. Abre o app Telefone para o usuário confirmar.
        if let url = URL(string: "tel://