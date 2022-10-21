import 'package:fivesdk/five_ad_manager.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fivesdk_method_channel.dart';

abstract class FivesdkPlatform extends PlatformInterface {
  /// Constructs a FivesdkPlatform.
  FivesdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FivesdkPlatform _instance = MethodChannelFivesdk();

  /// The default instance of [FivesdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFivesdk].
  static FivesdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FivesdkPlatform] when
  /// they register themselves.
  static set instance(FivesdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  FiveAdManager get adManager => throw UnimplementedError();

  Future<void> initialize({required String appId, required bool isTest}) {
    throw UnimplementedError();
  }
}
