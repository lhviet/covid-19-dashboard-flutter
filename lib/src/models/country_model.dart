class CountryModel {
  int _totalCases;
  int _newCases;
  int _totalDeaths;
  int _totalRecovered;
  int _activeCases;
  int _totalTests;
  int _seriousCritical;
  double _deaths1MPop;
  double _tests1MPop;
  double _totalCases1MPop;
  String _continent;
  String _country;

  int get totalCases => _totalCases;
  int get newCases => _newCases;
  int get totalDeaths => _totalDeaths;
  int get totalRecovered => _totalRecovered;
  int get activeCases => _activeCases;
  int get totalTests => _totalTests;
  int get seriousCritical => _seriousCritical;
  double get deaths1MPop => _deaths1MPop;
  double get tests1MPop => _tests1MPop;
  double get totalCases1MPop => _totalCases1MPop;
  String get continent => _continent;
  String get country => _country;

  dynamic _parseNumber(String value, {bool isDouble = false}) {
    String numStr = value.replaceAll(',', '');
    if (isDouble) {
      if (numStr.trim().length == 0)
        return 0.0;
      return double.tryParse(numStr);
    } else {
      if (numStr.trim().length == 0)
        return 0;
      return int.tryParse(numStr);
    }

  }

  CountryModel.fromJson(Map<String, dynamic> parsedJson) {
    _totalCases = _parseNumber(parsedJson['TotalCases']);
    _newCases = _parseNumber(parsedJson['NewCases']);
    _totalDeaths = _parseNumber(parsedJson['TotalDeaths']);
    _totalRecovered = _parseNumber(parsedJson['TotalRecovered']);
    _activeCases = _parseNumber(parsedJson['ActiveCases']);
    _totalTests = _parseNumber(parsedJson['TotalTests']);
    _seriousCritical = _parseNumber(parsedJson['Serious_Critical']);
    _deaths1MPop = _parseNumber(parsedJson['Deaths_1M_pop'], isDouble: true);
    _tests1MPop = _parseNumber(parsedJson['Tests_1M_Pop'], isDouble: true);
    _totalCases1MPop = _parseNumber(parsedJson['TotCases_1M_Pop'], isDouble: true);
    _continent = parsedJson['Continent'];
    _country = parsedJson['Country'];
  }
}