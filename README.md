# FiveSDK FLutter Plugin

This is a FiveSDK plugin for Flutter.

# Launch example app

To launch an example app for testing, create an `example/.env` file based on the `.env.example` file in the same directory. Please fill all values in according to your Five SDK settings.

# Usage in the app

First, initialize the SDK with the `initialize` method like this:

```
Fivesdk.initialize(appId: "xxx", isTest: true);
```

The `appId` is your application ID (App ID). Notice that the app ID differs depending on your active platform. For example, if your active platform is iOS, use your app ID for iOS. 

The `isTest` parameter should be true while testing.

Second, use the `FiveAd` widget to show a custom layout ad.

```
FiveAd(slotId: slotId, width: 320, height: 50);
```

Set three parameters at least: slotID, width, and height. Five Dashboard allows you to get all values for these parameters.
