import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'my_home_page.dart';

// Notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();
class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
class PaddedRaisedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PaddedRaisedButton({
    @required this.buttonText,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child: RaisedButton(child: Text(buttonText), onPressed: onPressed),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _adShown;
  BannerAd _bannerAd;
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        // print("BannerAd event $event");
        if (event == MobileAdEvent.loaded) {
          _adShown = true;
          setState((){});
        } else if (event == MobileAdEvent.failedToLoad) {
          _adShown = false;
          setState((){});
        }
      },
    );
  }

  final MethodChannel platform =
  MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  void initState() {
    super.initState();
    _adShown = false;
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()..load()..show();

    _requestIOSPermissions();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();

    super.dispose();
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, 'plain title', 'plain body', platformChannelSpecifics,
      payload: 'item x');
  }

  Future<void> _showNotificationWithNoBody() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, 'plain title', null, platformChannelSpecifics,
      payload: 'item x');
  }

  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> _showNotificationWithIconBadge() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'icon badge channel', 'icon badge name', 'icon badge description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(badgeNumber: 1);
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, 'icon badge title', 'icon badge body', platformChannelSpecifics,
      payload: 'item x');
  }

  Future<void> _showSoundUriNotification() async {
    // this calls a method over a platform channel implemented within the example app to return the Uri for the default
    // alarm sound and uses as the notification sound
    String alarmUri = await platform.invokeMethod('getAlarmUri');
    final x = UriAndroidNotificationSound(alarmUri);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'uri channel id', 'uri channel name', 'uri channel description',
      sound: x,
      playSound: true,
      styleInformation: DefaultStyleInformation(true, true));
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, 'uri sound title', 'uri sound body', platformChannelSpecifics);
  }

  Future<void> _showTimeoutNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'silent channel id',
      'silent channel name',
      'silent channel description',
      timeoutAfter: 3000,
      styleInformation: DefaultStyleInformation(true, true));
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'timeout notification',
      'Times out after 3 seconds', platformChannelSpecifics);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(new Container(
      height: 40,
    ));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: MyHomePage(title: 'COVID-19 Dashboard'),
        persistentFooterButtons: _adShown? fakeBottomButtons : null,
      ),
    );
  }
}