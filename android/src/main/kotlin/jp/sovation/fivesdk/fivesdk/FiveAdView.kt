package jp.sovation.fivesdk.fivesdk

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.LinearLayout
import com.five_corp.ad.*
import io.flutter.plugin.platform.PlatformView


internal class FiveAdView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView, FiveAdLoadListener {
    companion object {
        const val TAG = "FiveAdView"
    }

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

        val slotId = creationParams?.get("slotId") as String?

        // 広告のコンテナとなるビュー
        view = LinearLayout(context);

        // Five広告の初期化
        layout = FiveAdCustomLayout(context, slotId, width);
        layout.setLoadListener(this)
        layout.loadAdAsync()
    }

    override fun onFiveAdLoad(ad: FiveAdInterface) {
        Log.d("fivead", "success")
        view.addView(layout)
    }

    override fun onFiveAdLoadError(fiveAdInterface: FiveAdInterface, errorCode: FiveAdErrorCode) {
        Log.d(TAG, "onFiveAdError: slotId = " + fiveAdInterface.getSlotId().toString() + ", errorCode = " + errorCode)
    }
}