import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fivesdk_platform_interface.dart';

/// An implementation of [FivesdkPlatform] that uses method channels.
class MethodChannelFivesdk extends FivesdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fivesdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> healthCheck(String name) async {
    final msg = await methodChannel.invokeMethod<String>('healthCheck', {
      "name": name,
    });
    return msg;
  }

  @override
  Future<void> initialize({required String appId, required bool isTest}) async {
    await methodChannel.invokeMethod<String>('initialize', {
      "appId": appId,
      "isTest": isTest,
    });
  }
}
