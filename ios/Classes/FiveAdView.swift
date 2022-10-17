import Flutter
import UIKit
import FiveAd

class FiveAdViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
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
            binaryMessenger: messenger)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FiveAdView: NSObject, FlutterPlatformView, FADLoadDelegate {
    func fiveAdDidLoad(_ ad: FADAdInterface!) {
        let ad = self.adCustomLayout
        if ad != nil {
            mylog("load ad successfully")
            self._view.addSubview(ad!)

        }
    }
    
    func fiveAd(_ ad: FADAdInterface!, didFailedToReceiveAdWithError errorCode: FADErrorCode) {
        mylog("load ad failed, errorCode: \(errorCode.rawValue)")
    }
    
    private var _view: UIView
    private var adCustomLayout: FADAdViewCustomLayout?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        
        adCustomLayout = nil
        _view = UIView()
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
            adCustomLayout = FADAdViewCustomLayout(slotId: slotId, width: Float(widthDp))
            adCustomLayout!.setLoadDelegate(self)
            adCustomLayout!.loadAdAsync()
        }
    }

    func view() -> UIView {
        return _view
    }

}
