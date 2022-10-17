import 'package:flutter_test/flutter_test.dart';
import 'package:fivesdk/fivesdk_platform_interface.dart';
import 'package:fivesdk/fivesdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFivesdkPlatform
    with MockPlatformInterfaceMixin
    implements FivesdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FivesdkPlatform initialPlatform = FivesdkPlatform.instance;

  test('$MethodChannelFivesdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFivesdk>());
  });

  // test('getPlatformVersion', () async {
  //   Fivesdk fivesdkPlugin = Fivesdk();
  //   MockFivesdkPlatform fakePlatform = MockFivesdkPlatform();
  //   FivesdkPlatform.instance = fakePlatform;

  //   expect(await fivesdkPlugin.getPlatformVersion(), '42');
  // });
}
