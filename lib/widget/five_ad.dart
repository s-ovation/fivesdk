import 'package:fivesdk/fivesdk.dart';
import 'package:fivesdk/fivesdk_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ネイティブ側に渡すパラメータ
class FiveAdNativeParams {
  final int widthDp;
  final String slotId;

  FiveAdNativeParams({required this.slotId, required this.widthDp});

  Map<String, dynamic> encode() {
    return {
      "widthDp": widthDp,
      "slotId": slotId,
    };
  }
}

/// 広告読み込み成功のリスナー
typedef FiveAdLoadedListener = VoidCallback;

/// 広告読み込みエラーのリスナー
typedef FiveAdLoadErrorListener = Function(FiveAdLoadError err);

class Ad {
  Ad();

  FiveAdLoadErrorListener? loadErrorListener;
  FiveAdLoadedListener? loadedListener;
}

///
/// Five(LINE)広告
///
class FiveAd extends StatefulWidget {
  static String viewType = 'five-ad-view';

  final String slotId;
  final int width;
  final int height;

  final ad = Ad();

  FiveAd({
    super.key,
    required this.slotId,
    required this.width,
    required this.height,
  });

  @override
  State<FiveAd> createState() => _FiveAdState();

  /// 広告の読み込みが成功
  onAdLoaded() {
    debugPrint("ad loaded successfully: $slotId");
    if (ad.loadedListener != null) {
      ad.loadedListener!();
    }
  }

  /// 広告の読み込みが失敗
  onAdLoadError(FiveAdLoadError err) {
    debugPrint("ad loaded error: $err");
    if (ad.loadErrorListener != null) {
      ad.loadErrorListener!(err);
    }
  }
}

class _FiveAdState extends State<FiveAd> {
  bool enabled = true;
  Widget? _nativeAd;

  @override
  void initState() {
    // 広告マネージャに登録
    Fivesdk.adManager.addAd(widget);

    widget.ad.loadedListener = (() {
      setState(() {
        enabled = true;
      });
    });

    widget.ad.loadErrorListener = (err) {
      setState(() {
        enabled = false;
      });
    };

    super.initState();
  }

  @override
  void dispose() {
    Fivesdk.adManager.removeAd(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("slotId: ${widget.slotId}");

    return LayoutBuilder(builder: (context, constraint) {
      // ネイティブ側に渡すパラメータ
      final widthDp = (constraint.biggest.width).toInt();

      final params =
          FiveAdNativeParams(widthDp: widthDp, slotId: widget.slotId).encode();

      _nativeAd ??= _getNativeAdView(params);
      return SizedBox(
        height: enabled ? null : 0,
        child: AspectRatio(
          aspectRatio: widget.width / widget.height,
          child: _nativeAd,
        ),
      );
    });
  }

  // Fiveのネイティブビューを取得
  Widget _getNativeAdView(Map<String, dynamic> params) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: FiveAd.viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: params,
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.android:
        return AndroidView(
          viewType: FiveAd.viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: params,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError("Unsupported platform view");
    }
  }
}
