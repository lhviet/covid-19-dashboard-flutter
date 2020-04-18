import 'package:coronavirusdashboard/src/models/country_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../types.dart';

class ListItemCountryRecordWidget extends StatelessWidget {
  const ListItemCountryRecordWidget({
    Key key,
    @required this.index,
    @required this.countryModel,
    @required this.displayType,
    this.isMarkedCountry,
    this.isPlaceIconSelected,
    @required this.onTapPlaceIcon,
  }) : super(key: key);

  final int index;
  final CountryModel countryModel;
  final CountryModelSortableFieldEnum displayType;
  final bool isMarkedCountry;
  final bool isPlaceIconSelected;
  final Function(String) onTapPlaceIcon;

  String _formatNumber(int num) => NumberFormat.decimalPattern('en_US').format(num);
  TextStyle _getTextStyle([bool isHighlight=false]) =>
      (
          isHighlight ?
          TextStyle(fontSize: 16,
              color: Colors.deepOrangeAccent,
              fontStyle: FontStyle.italic) :
          TextStyle(fontSize: 17, color: Colors.black87)
      );

  Text _getDisplayText() {
    int value = this.countryModel.totalCases;
    switch (this.displayType) {
      case CountryModelSortableFieldEnum.ACTIVE:
        value = this.countryModel.activeCases;
        break;
      case CountryModelSortableFieldEnum.RECOVERED:
        value = this.countryModel.totalRecovered;
        break;
      case CountryModelSortableFieldEnum.DEATHS:
        value = this.countryModel.totalDeaths;
        break;
      case CountryModelSortableFieldEnum.CONFIRMED:
      default:
    }

    String valueStr = '';
    if (value != null && value > 0) {
      valueStr = _formatNumber(value);
    }

    return Text(valueStr, style: _getTextStyle(), textAlign: TextAlign.end);
  }

  Text _getDisplayPercentageText() {
    int value = 0;
    Color color = Colors.orange;
    switch (this.displayType) {
      case CountryModelSortableFieldEnum.ACTIVE:
        value = this.countryModel.activeCases;
        break;
      case CountryModelSortableFieldEnum.RECOVERED:
        value = this.countryModel.totalRecovered;
        color = Colors.green;
        break;
      case CountryModelSortableFieldEnum.DEATHS:
        value = this.countryModel.totalDeaths;
        color = Colors.black54;
        break;
      case CountryModelSortableFieldEnum.CONFIRMED:
      default:
    }

    String valueStr = '';
    if (value != null && value > 0 && this.displayType != CountryModelSortableFieldEnum.CONFIRMED) {
      valueStr = ' ${((value / this.countryModel.totalCases) * 100).toStringAsFixed(1)}%';
    }

    return Text(
      valueStr,
      style: TextStyle(
        fontSize: 14,
        color: color,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.end,
    );
  }

  InkWell _getDisplayPlaceIcon() {
    return InkWell(
        onTap: () => this.onTapPlaceIcon(this.countryModel.country),
        child: Icon(
          Icons.place,
          color: this.isPlaceIconSelected ? Colors.pinkAccent : Colors.black45,
          size: 24.0,
          semanticLabel: 'Text to announce in accessibility modes',
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget _item1() => Expanded(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("${this.index + 1} ", style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            )),
            Expanded(child: Text(this.countryModel.country, style: _getTextStyle())),
          ],
      ),
      flex: 3,
    );

    Widget _item2() =>
        Expanded(
          child: this.countryModel.newCases > 0 ? Text(
              '+${_formatNumber(this.countryModel.newCases)}',
              style: _getTextStyle(true)) : Text(''),
          flex: 1,
    );

    final List<Widget> item3Children = this.displayType != CountryModelSortableFieldEnum.CONFIRMED ?
    [
      _getDisplayText(),
      _getDisplayPercentageText(),
    ] : [
      _getDisplayText(),
      _getDisplayPercentageText(),
      _getDisplayPlaceIcon()
    ];
    Widget _item3() => Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: item3Children,
      ),
        flex: 2,
    );

    final bgColor = this.isMarkedCountry == true ?
      Colors.yellow[100] :
      this.index % 2 == 1 ? Colors.grey[100] : Colors.transparent;

    return Container(
      height: 45,
      padding: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black54,
            width: 0.1,
          ),
        ),
        color: bgColor,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_item1(), _item2(), _item3()],
      ),
    );
  }
}
