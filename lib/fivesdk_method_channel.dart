import 'package:fivesdk/five_ad_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fivesdk_platform_interface.dart';

/// An implementation of [FivesdkPlatform] that uses method channels.
class MethodChannelFivesdk extends FivesdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('jp.sovation.fivesdk.fivesdk');

  late final FiveAdManager _adManager;

  MethodChannelFivesdk() {
    _adManager = FiveAdManager(methodChannel);
  }

  @override
  FiveAdManager get adManager => _adManager;

  @override
  Future<void> initialize({required String appId, required bool isTest}) async {
    await methodChannel.invokeMethod<String>('initialize', {
      "appId": appId,
      "isTest": isTest,
    });
  }
}
