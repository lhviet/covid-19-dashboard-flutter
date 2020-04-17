import 'package:flutter/material.dart';

import 'blocs/summary_bloc.dart';
import 'ui/summary_ui.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;

  void _setLoadingState(bool loadingState) {
    setState(() {
      _isLoading = loadingState;
    });
  }

  Future<void> _refreshData() async {
    _setLoadingState(true);
    await bloc.fetchSummary();
    _setLoadingState(false);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
//        child: SummaryList(),
        child: new RefreshIndicator(
          child: SummaryList(),
          onRefresh: _refreshData,
        ) ,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent.withAlpha(180),
        onPressed: _refreshData,
        tooltip: 'Renew',
        child: _isLoading ? CircularProgressIndicator(backgroundColor: Colors.white) : Icon(Icons.autorenew),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
