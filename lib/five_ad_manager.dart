import 'package:fivesdk/fivesdk_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widget/five_ad.dart';

class FiveAdManager {
  final MethodChannel channel;
  final Map<String, FiveAd> adMap = {};

  FiveAdManager(this.channel) {
    channel.setMethodCallHandler((call) => _onMethodCall(call));
  }

  /// 広告を管理対象に追加
  addAd(FiveAd ad) {
    if (adMap.containsKey(ad.slotId) == false) {
      adMap[ad.slotId] = ad;
    }
  }

  /// 広告を管理対象から削除
  removeAd(FiveAd ad) {
    adMap.remove(ad.slotId);
  }

  /// 広告オブジェクトを取得
  FiveAd? _getAd(String slotId) {
    return adMap[slotId];
  }

  /// ネイティブ側からイベントが呼ばれた
  _onMethodCall(MethodCall call) {
    try {
      debugPrint("onMethodCall: ${call.method} ${call.arguments}");
      switch (call.method) {
        case "onAdLoaded":
          onAdLoaded(call.arguments);
          break;
        case "onAdLoadError":
          onAdLoadError(call.arguments);
          break;
      }
    } catch (err) {
      // ignore unexpected error
      debugPrint(err.toString());
    }
  }

  /// 広告枠の読み込み成功をウィジェットに通知
  onAdLoaded(dynamic args) {
    final id = args;
    final ad = _getAd(id);
    if (ad == null) {
      return;
    }
    ad.onAdLoaded();
  }

  /// 広告枠の読み込みエラーをウィジェットに通知
  onAdLoadError(Map args) {
    final id = args["id"] as String;
    final reason = args["reason"] ?? "";
    final ad = _getAd(id);
    if (ad == null) {
      return;
    }
    FiveAdLoadError err;
    switch (reason) {
      case "NetworkError":
        err = FiveAdLoadError.networkError;
        break;
      case "NoAd":
        err = FiveAdLoadError.noAd;
        break;
      case "BadAppId":
        err = FiveAdLoadError.badAppId;
        break;
      case "StorageError":
        err = FiveAdLoadError.storageError;
        break;
      case "InternalError":
        err = FiveAdLoadError.internalError;
        break;
      case "InvalidState":
        err = FiveAdLoadError.invalidState;
        break;
      case "BadSlotId":
        err = FiveAdLoadError.badSlotId;
        break;
      case "Suppressed":
        err = FiveAdLoadError.suppressed;
        break;
      default:
        err = FiveAdLoadError.unknown;
    }
    ad.onAdLoadError(err);
  }
}
