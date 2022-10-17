package jp.sovation.fivesdk.fivesdk

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.five_corp.ad.FiveAd
import com.five_corp.ad.FiveAdConfig

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FivesdkPlugin */
class FivesdkPlugin : FlutterPlugin, MethodCallHandler , ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var activity : Activity
    private lateinit var context : Context

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "fivesdk")
        channel.setMethodCallHandler(this)

        context = binding.applicationContext

        binding.platformViewRegistry
                .registerViewFactory("five-ad-view", FiveAdViewFactory())
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "healthCheck") {
            val name = call.argument<String>("name");
            result.success("Hello $name");
        } else if( call.method == "initialize" ){
            // FiveAd SDKの初期化

            // テストモードをデフォルトとする
            var isTest = call.argument<Boolean>("isTest") ?: true;
            var appId = call.argument<String>("appId")
            if(appId==null){
                result.error("noAppId", "App ID is not set", null);
                return
            }
            var config = FiveAdConfig(appId);
            config.isTest = isTest
            FiveAd.initialize(context, config)
            fivesdklogger("FiveAd initialized")
        }
        else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    // 以下のコールバックは不要なので特に何もしない
    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }
}
