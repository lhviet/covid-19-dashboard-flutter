import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget FetchedTimeWidget(DateTime fetchedAt) =>
    Container(
      height: 30,
      padding: EdgeInsets.only(right: 15),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
              new DateFormat.MMMMEEEEd().add_Hms().format(fetchedAt.toLocal()),
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.black45,
              )),
        ],
      ),
    );
