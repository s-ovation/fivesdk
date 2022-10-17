import 'fivesdk_platform_interface.dart';

class Fivesdk {
  static Future<void> initialize(
      {required String appId, required bool isTest}) {
    return FivesdkPlatform.instance.initialize(
      appId: appId,
      isTest: isTest,
    );
  }

  static Future<String?> healthCheck(String name) {
    return FivesdkPlatform.instance.healthCheck(name);
  }
}
