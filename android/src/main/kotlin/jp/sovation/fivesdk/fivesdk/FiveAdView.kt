package jp.sovation.fivesdk.fivesdk

import android.content.Context
import android.view.View
import android.widget.LinearLayout
import com.five_corp.ad.*
import io.flutter.plugin.platform.PlatformView

/**
 * Five広告のビュークラス
 */
internal class FiveAdView(context: Context, id: Int, private val adManager: FiveAdManager, creationParams: Map<String?, Any?>?) : PlatformView, FiveAdLoadListener {
    private val slotId: String?
    private val view: LinearLayout
    private val layout: FiveAdCustomLayout

    override fun getView(): View {
        return view
    }

    override fun dispose() {
    }

    init {
        // パラメータの受け取り
        var widthDp = creationParams?.get("widthDp") as Int?
        if(widthDp == null){
            widthDp = 320
        }
        // DP->PX変換
        val metrics = context.resources.displayMetrics
        val width = (widthDp * metrics.density).toInt()

        slotId = creationParams?.get("slotId") as String?

        // 広告のコンテナとなるビュー
        view = LinearLayout(context);

        // Five広告の初期化
        layout = FiveAdCustomLayout(context, slotId, width);
        layout.setLoadListener(this)
        layout.loadAdAsync()
    }

    // 広告が読み込まれた
    override fun onFiveAdLoad(ad: FiveAdInterface) {
        fivesdklogger("ad loaded successfully")
        view.addView(layout)
        if( this.slotId != null ){
            adManager.onAdLoaded(this.slotId)
        }
    }

    // 広告の読み込みに失敗
    override fun onFiveAdLoadError(fiveAdInterface: FiveAdInterface, errorCode: FiveAdErrorCode) {
        fivesdklogger("onFiveAdError: slotId = " + fiveAdInterface.getSlotId().toString() + ", errorCode = " + errorCode)
        if( this.slotId != null ){
            adManager.onAdLoadError(this.slotId, errorCode);
        }
    }
}