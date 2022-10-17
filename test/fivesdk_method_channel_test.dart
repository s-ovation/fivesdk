import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fivesdk/fivesdk_method_channel.dart';

void main() {
  MethodChannelFivesdk platform = MethodChannelFivesdk();
  const MethodChannel channel = MethodChannel('fivesdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
