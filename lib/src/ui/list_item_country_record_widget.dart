import 'package:coronavirusdashboard/src/models/country_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../types.dart';

class ListItemCountryRecordWidget extends StatelessWidget {
  const ListItemCountryRecordWidget({
    Key key,
    @required this.countryModel,
    @required this.displayType,
  }) : super(key: key);

  final CountryModel countryModel;
  final CountryModelSortableFieldEnum displayType;

  String _formatNumber(int num) => NumberFormat.decimalPattern('en_US').format(num);
  TextStyle _getTextStyle([bool isHighlight=false]) =>
      (
          isHighlight ?
          TextStyle(fontSize: 18,
              color: Colors.deepOrangeAccent,
              fontStyle: FontStyle.italic) :
          TextStyle(fontSize: 18, color: Colors.black87)
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
    if (value != null && value > 0 && this.displayType != CountryModelSortableFieldEnum.CONFIRMED) {
      valueStr = ' ${((value / this.countryModel.totalCases) * 100).toStringAsFixed(1)}%';
    }

    return Text(
      valueStr,
      style: TextStyle(
        fontSize: 14,
        color: Colors.redAccent,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.end,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _item1() => Expanded(
      child: Text(this.countryModel.country, style: _getTextStyle()),
      flex: 2,
    );

    Widget _item2() =>
        Expanded(
          child: this.countryModel.newCases > 0 ? Text(
              '+${_formatNumber(this.countryModel.newCases)}',
              style: _getTextStyle(true)) : Text(''),
          flex: 1,
    );

    Widget _item3() => Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _getDisplayText(),
          _getDisplayPercentageText(),
        ],
      ),
        flex: 2,
    );

    return Container(
      height: 45,
      margin: EdgeInsets.only(left: 7, right: 7),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black54,
            width: 0.1,
          ),
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_item1(), _item2(), _item3()],
      ),
    );
  }
}