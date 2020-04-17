import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListItemColorWidget extends StatelessWidget {
  static const Confirmed = 0;
  static const Recovered = 1;
  static const Deaths = 2;

  const ListItemColorWidget({
    Key key,
    @required this.itemType,
    @required this.value,
    @required this.confirmed,
  }) : super(key: key);

  final int itemType;
  final int value;
  final int confirmed;

  Color _getBackgroundColor() {
    switch (this.itemType) {
      case ListItemColorWidget.Confirmed:
        return Colors.amber[500];
      case ListItemColorWidget.Recovered:
        return Colors.lightGreen[300];
      case ListItemColorWidget.Deaths:
      default:
        return Colors.blueGrey[200];
    }
  }

  Color _getTextColor() {
    switch (this.itemType) {
      case ListItemColorWidget.Confirmed:
        return Colors.black;
      case ListItemColorWidget.Recovered:
        return Colors.black87;
      case ListItemColorWidget.Deaths:
      default:
        return Colors.black45;
    }
  }

  Text _getLabelText() {
    String getPercentage(int sum, int part) =>
        ((part / sum) * 100).toStringAsFixed(1);

    String labelStr;
    switch (this.itemType) {
      case ListItemColorWidget.Confirmed:
        labelStr = "Confirmed (World)";
        break;
      case ListItemColorWidget.Recovered:
        labelStr = "Recovered (${getPercentage(this.confirmed, this.value)}%)";
        break;
      case ListItemColorWidget.Deaths:
      default:
        labelStr = "Death (${getPercentage(this.confirmed, this.value)}%)";
    }

    return Text(
      labelStr,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: _getTextColor()),
    );
  }

  Text _getValueText() => Text(
    NumberFormat.decimalPattern('en_US').format(this.value),
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: _getTextColor()),
  );

  @override
  Widget build(BuildContext context) => Container(
    height: 50,
    padding: EdgeInsets.only(left: 15, right: 15),
    color: _getBackgroundColor(),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getLabelText(),
        _getValueText(),
      ],
    ),
  );
}
