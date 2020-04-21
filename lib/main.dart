import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workmanager/workmanager.dart';

import 'src/my_app.dart';
import 'src/blocs/summary_bloc.dart';

// Background periodic call
const fetchSummaryTaskId = '1';
const fetchSummaryTaskName = 'fetchSummaryTask';
void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case fetchSummaryTaskName:
        await bloc.fetchSummary();
        break;
      default:
    }
    return Future.value(true);
  });
}

// Notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager.initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );

  Workmanager.registerPeriodicTask(
    fetchSummaryTaskId,
    fetchSummaryTaskName,
    frequency: Duration(minutes: 15),
    tag: 'fetch-summary',
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  // Notification
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
      (int id, String title, String body, String payload) async {
      didReceiveLocalNotificationSubject.add(ReceivedNotification(
        id: id, title: title, body: body, payload: payload));
    });
  var initializationSettings = InitializationSettings(
    initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });

  runApp(MyApp());
}