import Flutter
import UIKit
import FiveAd

public class SwiftFivesdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "fivesdk", binaryMessenger: registrar.messenger())
        let instance = SwiftFivesdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let factory = FiveAdViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "five-ad-view")
    }
    
    // Flutter側からメソッド呼び出しされたときに呼ばれる
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            // FiveAdの初期化
            
            // パラメータの取得
            var appId: String? = "";
            var isTest: Bool = true; // テストモードをデフォルト
            let dic = (call.arguments as? Dictionary<String,Any>)
            if( dic == nil ){
                // アプリIDがない場合はエラー
                result(FlutterError(code: "noParameters", message: "No parameters set", details: nil));
                return
            }
            appId = dic!["appId"] as? String
            if appId == nil {
                mylog("no app Id")
                // アプリIDがない場合はエラー
                result(FlutterError(code: "noAppId", message: "App ID is not set", details: nil));
                return
            }
            isTest = dic!["isTest"] as? Bool ?? true;
            mylog("appId: \(appId!), isTest: \(isTest)");

            // 初期化
            let config: FADConfig = FADConfig(appId: appId)
            config.isTest = isTest
            FADSettings.register(config)
            mylog("initialized")
            break
        default:
            result(FlutterMethodNotImplemented)
            break;
        }
    }
}
