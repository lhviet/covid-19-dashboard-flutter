import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'src/my_app.dart';
import 'src/blocs/summary_bloc.dart';

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

  runApp(MyApp());
}