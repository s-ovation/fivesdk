//
//  FiveAdManager.swift
//  fivesdk
//

import Foundation
import FiveAd

// FiveADの広告管理（主に、イベント通知)
class FiveAdManager {
    private var channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
        
    // 広告の読み込みが完了したことをFlutter側に通知
    func onAdLoaded(id: String) {
        self.channel.invokeMethod("onAdLoaded", arguments: id)
    }
    
    // 広告読み込みエラーが発生したことをFlutter側に通知
    func onAdLoadError(id: String, errorCode: FADErrorCode) {
        // errorCode -> logical reason message
        // https://adsnetwork-docs.linebiz.com/fivesdk-ios/trouble-shooting/quick-diagnosis.html
        var reason = ""
        switch( errorCode.rawValue ){
        case 1: reason = "NetworkError"
        case 2: reason = "NoAd"
        case 4: reason = "BadAppId"
        case 5: reason = "StorageError"
        case 6: reason = "InternalError"
        case 7: reason = "InvalidState"
        case 9: reason = "BadSlotId"
        case 10: reason = "Suppressed"
        default: reason = "unknown"
        }
        
        let args: Dictionary<String, String> = [
            "id": id,
            "reason": reason
        ]
        
        self.channel.invokeMethod("onAdLoadError", arguments: args)
    }
}
