import 'package:coronavirusdashboard/src/models/country_model.dart';

class SummaryModel {
  int _cases;
  int _deaths;
  int _recovered;
  DateTime _lastFetch;

  List<CountryModel> _countries = [];

  int get recovered => _recovered;
  int get deaths => _deaths;
  int get cases => _cases;
  DateTime get lastFetch => _lastFetch;

  List<CountryModel> get countries => _countries;

  SummaryModel.fromJson(Map<String, dynamic> parsedJson) {
    final List<dynamic> reports = parsedJson['reports'];
    if (reports != null && reports.length > 0) {
      final dynamic report = reports[0];

      _cases = report['cases'];
      _deaths = report['deaths'];
      _recovered = report['recovered'];
      _lastFetch = new DateTime.now();

      if (report['table'] != null && report['table'].length > 0) {
        final dynamic countryReports = report['table'][0];
        if (countryReports != null && countryReports.length > 0) {
          Set.from(countryReports).forEach((element) => _countries
              .add(CountryModel.fromJson(element)));

          // Remove a duplicate World = Total
          _countries.removeLast();

          // Sort by active cases
          _countries.sort((a, b) => b.activeCases.compareTo(a.activeCases));
        }
      }
    }
  }
}