import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../types.dart';
import '../models/summary_model.dart';
import '../blocs/summary_bloc.dart';

import 'list_item_color_widget.dart';
import 'list_item_country_display_buttons_widget.dart';
import 'list_item_country_header_widget.dart';
import 'list_item_country_record_widget.dart';
import 'fetched_time_widget.dart';

class SummaryList extends StatefulWidget {
  @override
  SummaryListState createState() => SummaryListState();
}

class SummaryListState extends State<SummaryList> {
  CountryModelSortableFieldEnum _displayType = CountryModelSortableFieldEnum.CONFIRMED;
  CountryModelSortableFieldEnum _sortingField = CountryModelSortableFieldEnum.CONFIRMED;
  SortingDirectionEnum _sortingDirection = SortingDirectionEnum.DESC;
  bool _sorted = true;

  SummaryModel _summaryModel;

  @override
  void initState() {
    super.initState();
    _loadSummaryFromPrefs();
    bloc.fetchSummary();
  }

  _setDisplayType(CountryModelSortableFieldEnum field) => setState(() {
    _displayType = field;
  });

  void _loadSummaryFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String summaryStr = prefs.getString('summary');
    if (summaryStr != null) {
      setState(() {
        _summaryModel = SummaryModel.fromJson(json.decode(summaryStr));
      });
    }
  }

  SortingDirectionEnum _inverseDirection(SortingDirectionEnum dir) =>
      dir == SortingDirectionEnum.DESC
          ? SortingDirectionEnum.ASC
          : SortingDirectionEnum.DESC;

  void _sortCountry() => setState(() {
    _sorted = false;
        if (_sortingField == CountryModelSortableFieldEnum.COUNTRY) {
          _sortingDirection = _inverseDirection(_sortingDirection);
          return;
        }
        _sortingField = CountryModelSortableFieldEnum.COUNTRY;
        _sortingDirection = SortingDirectionEnum.DESC;
      });

  void _sortNewCases() => setState(() {
    _sorted = false;
        if (_sortingField == CountryModelSortableFieldEnum.NEW_CASES) {
          _sortingDirection = _inverseDirection(_sortingDirection);
          return;
        }
        _sortingField = CountryModelSortableFieldEnum.NEW_CASES;
        _sortingDirection = SortingDirectionEnum.DESC;
      });

  void _sortItem3() => setState(() {
    _sorted = false;
        if (_sortingField == _displayType) {
          _sortingDirection = _inverseDirection(_sortingDirection);
          return;
        }
        _sortingField = _displayType;
        _sortingDirection = SortingDirectionEnum.DESC;
      });

  void _sorting(SummaryModel summaryModel) {
    if (_sorted) {
      return;
    }
    switch (_sortingField) {
      case CountryModelSortableFieldEnum.COUNTRY:
        summaryModel.countries.sort((a, b) => _sortingDirection == SortingDirectionEnum.DESC
            ? b.country.compareTo(a.country)
            : a.country.compareTo(b.country));
        break;
      case CountryModelSortableFieldEnum.NEW_CASES:
        summaryModel.countries.sort((a, b) => _sortingDirection == SortingDirectionEnum.DESC
            ? b.newCases.compareTo(a.newCases)
            : a.newCases.compareTo(b.newCases));
        break;
      case CountryModelSortableFieldEnum.ACTIVE:
        summaryModel.countries.sort((a, b) => _sortingDirection == SortingDirectionEnum.DESC
            ? b.activeCases.compareTo(a.activeCases)
            : a.activeCases.compareTo(b.activeCases));
        break;
      case CountryModelSortableFieldEnum.RECOVERED:
        summaryModel.countries.sort((a, b) => _sortingDirection == SortingDirectionEnum.DESC
            ? b.totalRecovered.compareTo(a.totalRecovered)
            : a.totalRecovered.compareTo(b.totalRecovered));
        break;
      case CountryModelSortableFieldEnum.DEATHS:
        summaryModel.countries.sort((a, b) => _sortingDirection == SortingDirectionEnum.DESC
            ? b.totalDeaths.compareTo(a.totalDeaths)
            : a.totalDeaths.compareTo(b.totalDeaths));
        break;
      case CountryModelSortableFieldEnum.CONFIRMED:
        summaryModel.countries.sort((a, b) => _sortingDirection == SortingDirectionEnum.DESC
            ? b.totalCases.compareTo(a.totalCases)
            : a.totalCases.compareTo(b.totalCases));
    }
    _sorted = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.summary,
        builder: (context, AsyncSnapshot<SummaryModel> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot.data);
          } else if (_summaryModel != null) {
            return buildList(_summaryModel);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(SummaryModel summaryModel) {
    final values = [summaryModel.cases, summaryModel.recovered, summaryModel.deaths];

    // Sorting
    _sorting(summaryModel);

    return ListView.builder(
        itemCount: summaryModel.countries.length + 6,
        itemBuilder: (BuildContext context, int index) {
          if (index < 3) {
            return ListItemColorWidget(
                itemType: index, value: values[index], confirmed: values[0]
            );
          } else if (index == 3) {
            print(summaryModel.lastFetch);
            return FetchedTimeWidget(summaryModel.lastFetch);
          } else if (index == 4) {
            return ListItemCountryDisplayButtonsWidget(
              selectedField: _displayType,
              onPressed: _setDisplayType,
            );
          } else if (index == 5) {
            return ListItemCountryHeaderWidget(
              displayType: _displayType,
              onTap1: _sortCountry,
              onTap2: _sortNewCases,
              onTap3: _sortItem3,
            );
          } else {
            return ListItemCountryRecordWidget(
              countryModel: summaryModel.countries[index - 6],
              displayType: _displayType,
            );
          }
        });
  }
}
