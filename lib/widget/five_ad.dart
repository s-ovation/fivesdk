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

///
/// Five(LINE)広告
///
class FiveAd extends StatelessWidget {
  // This is used in the platform side to register the view.
  static String viewType = 'five-ad-view';

  final String slotId;
  final int width;
  final int height;

  const FiveAd(
      {super.key,
      required this.slotId,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    debugPrint("slotId: $slotId");

    return LayoutBuilder(builder: (context, constraint) {
      // ネイティブ側に渡すパラメータ
      final widthDp = (constraint.biggest.width).toInt();

      final params =
          FiveAdNativeParams(widthDp: widthDp, slotId: slotId).encode();
      return AspectRatio(
        aspectRatio: width / height,
        child: _getNativeAdView(params),
      );
    });
  }

  // Fiveのネイティブビューを取得
  Widget _getNativeAdView(Map<String, dynamic> params) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: params,
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.android:
        return AndroidView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: params,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError("Unsupported platform view");
    }
  }
}
