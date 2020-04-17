import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'my_home_page.dart';

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
  @override
  void initState() {
    super.initState();
    _adShown = false;
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()..load()..show();
  }
  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: MyHomePage(title: 'COVID-19 Dashboard'),
        persistentFooterButtons: _adShown? fakeBottomButtons : null,
      ),
    );
  }
}
