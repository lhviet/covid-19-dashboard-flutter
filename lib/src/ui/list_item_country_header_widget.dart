import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../types.dart';

class ListItemCountryHeaderWidget extends StatelessWidget {
  const ListItemCountryHeaderWidget({
    Key key,
    @required this.displayType,
    this.onTap1,
    this.onTap2,
    this.onTap3,
  }) : super(key: key);

  final CountryModelSortableFieldEnum displayType;

  final GestureTapCallback onTap1;
  final GestureTapCallback onTap2;
  final GestureTapCallback onTap3;

  TextStyle _getTextStyle() => TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

  Text _getDisplayText() {
    String label = 'Total';
    switch (this.displayType) {
      case CountryModelSortableFieldEnum.ACTIVE:
        label = 'Active';
        break;
      case CountryModelSortableFieldEnum.RECOVERED:
        label = 'Recovered';
        break;
      case CountryModelSortableFieldEnum.DEATHS:
        label = 'Deaths';
        break;
      default:
    }

    return Text(label, style: _getTextStyle(), textAlign: TextAlign.end);
  }

  @override
  Widget build(BuildContext context) {
    Widget _item1() => Expanded(
        child: InkWell(
          onTap: this.onTap1,
          child: Text('Country', style: _getTextStyle()),
        ),
        flex: 3,
    );

    Widget _item2() => Expanded(
        child: InkWell(
          onTap: this.onTap2,
          child: Text('New', style: _getTextStyle()),
        ),
        flex: 1,
    );

    Widget _item3() => Expanded(
        child: InkWell(
          onTap: this.onTap3,
          child: _getDisplayText(),
        ),
        flex: 2,
    );

    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 7, right: 7),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_item1(), _item2(), _item3()],
      ),
    );
  }
}
