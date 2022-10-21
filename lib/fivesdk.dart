import 'package:fivesdk/five_ad_manager.dart';

import 'fivesdk_platform_interface.dart';

class Fivesdk {
  static Future<void> initialize(
      {required String appId, required bool isTest}) {
    return FivesdkPlatform.instance.initialize(
      appId: appId,
      isTest: isTest,
    );
  }

  static FiveAdManager get adManager => FivesdkPlatform.instance.adManager;
}
