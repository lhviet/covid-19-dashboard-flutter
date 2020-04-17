import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../types.dart';

class ListItemCountryDisplayButtonsWidget extends StatelessWidget {
  const ListItemCountryDisplayButtonsWidget({
    Key key,
    @required this.selectedField,
    @required this.onPressed,
  }) : super(key: key);

  final CountryModelSortableFieldEnum selectedField;
  final void Function(CountryModelSortableFieldEnum) onPressed;

  @override
  Widget build(BuildContext context) {

    Widget _getButton(CountryModelSortableFieldEnum displayField) {
      String label = 'Total';
      switch (displayField) {
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
      return this.selectedField != displayField ? OutlineButton(
        child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
        color:  Colors.blueAccent,
        onPressed: () => onPressed(displayField),
      ) : FlatButton(
        child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
        disabledColor: Colors.blue[400],
        disabledTextColor: Colors.white,
        onPressed: null,
      );
    }

    return Container(
      height: 40,
      padding: EdgeInsets.only(right: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _getButton(CountryModelSortableFieldEnum.CONFIRMED),
          _getButton(CountryModelSortableFieldEnum.ACTIVE),
          _getButton(CountryModelSortableFieldEnum.RECOVERED),
          _getButton(CountryModelSortableFieldEnum.DEATHS),
        ],
      ),
    );
  }
}
