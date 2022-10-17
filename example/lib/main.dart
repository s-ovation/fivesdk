import 'package:fivesdk_example/five_ad.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fivesdk/fivesdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _initPlugin();
  }

  _initPlugin() {
    final appId = defaultTargetPlatform == TargetPlatform.android
        ? dotenv.get("ANDROID_FIVE_APP_ID")
        : dotenv.get("IOS_FIVE_APP_ID");
    debugPrint("appId: $appId");
    Fivesdk.initialize(appId: appId, isTest: true);
  }

  @override
  Widget build(BuildContext context) {
    final iosSlotId = dotenv.get("IOS_SLOT");
    final androidSlotId = dotenv.get("ANDROID_SLOT");
    final slotId = defaultTargetPlatform == TargetPlatform.android
        ? androidSlotId
        : iosSlotId;

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Five Ad Sample'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          FiveAd(
            slotId: slotId,
            width: 320,
            height: 50,
          ),
        ]),
      ),
    ));
  }
}