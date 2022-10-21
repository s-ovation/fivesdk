package jp.sovation.fivesdk.fivesdk

import com.five_corp.ad.FiveAdErrorCode
import io.flutter.plugin.common.MethodChannel

class FiveAdManager(private val channel: MethodChannel) {
    // 広告読み込み成功のイベント送信
    fun onAdLoaded(id: String) {
        this.channel.invokeMethod("onAdLoaded", id);
    }

    // 広告読み込み失敗のイベント送信
    fun onAdLoadError(id: String, errorCode: FiveAdErrorCode) {
        val reason = when (errorCode.value) {
            1 -> {
                "NetworkError";
            }
            2 -> {
                "NoAd"
            }
            3 -> {
                "BadAppId"
            }
            5 -> {
                "StorageError"
            }
            6 -> {
                "InternalError"
            }
            8 -> {
                "InvalidState"
            }
            9 -> {
                "BadSlotId"
            }
            10 -> {
                "Suppressed"
            }
            else -> {
                "unknown"
            }
        }
        this.channel.invokeMethod("onAdLoadError", mapOf("id" to id, "reason" to reason))
    }
}

