import Flutter
import UIKit
import FiveAd

class FiveAdViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var adManager: FiveAdManager

    init(messenger: FlutterBinaryMessenger, adManager: FiveAdManager) {
        self.messenger = messenger
        self.adManager = adManager
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FiveAdView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            adManager: self.adManager
        );
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FiveAdView: NSObject, FlutterPlatformView, FADLoadDelegate {
    private var _view: UIView
    private var adCustomLayout: FADAdViewCustomLayout?
    private var adManager: FiveAdManager
    private var slotId: String

    // 広告の読み込み成功時
    func fiveAdDidLoad(_ ad: FADAdInterface!) {
        let ad = self.adCustomLayout
        if ad != nil {
            mylog("load ad successfully")
            self._view.addSubview(ad!)
            self.adManager.onAdLoaded(id: self.slotId)
        }
    }
    
    // 広告の読み込み失敗時
    func fiveAd(_ ad: FADAdInterface!, didFailedToReceiveAdWithError errorCode: FADErrorCode) {
        mylog("load ad failed, errorCode: \(errorCode.rawValue)")
        self.adManager.onAdLoadError(id: self.slotId, errorCode: errorCode)
    }
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        adManager: FiveAdManager
    ) {

        self.adManager = adManager
        self.adCustomLayout = nil
        self._view = UIView()
        self.slotId = ""
        super.init()

        // 広告枠の初期化
        var slotId: String? = ""
        var widthDp: Int = 320
        let dic = (args as? Dictionary<String,Any>)
        
        if( dic != nil ){
            slotId = dic!["slotId"] as? String
            if (dic!["widthDp"] as? Int) != nil {
                widthDp = dic!["widthDp"] as! Int
            }
        }
        
        if slotId != nil {
            mylog("init ad: slotId = \(slotId!), widthDp = \(widthDp)")
            self.slotId = slotId!
            adCustomLayout = FADAdViewCustomLayout(slotId: slotId, width: Float(widthDp))
            adCustomLayout!.setLoadDelegate(self)
            adCustomLayout!.loadAdAsync()
        }
    }

    func view() -> UIView {
        return _view
    }

}
