package jp.sovation.fivesdk.fivesdk

import android.content.Context
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FiveAdViewFactory(private val adManager: FiveAdManager) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return FiveAdView(context, viewId, adManager, creationParams)
    }
}