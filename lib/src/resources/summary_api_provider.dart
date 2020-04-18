import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/summary_model.dart';

class SummaryApiProvider {
  Future<SummaryModel> fetchSummary() async {
    final String _apiUrl = "https://covid19-server.chrismichael.now.sh/api/v1/AllReports";
    Client client = Client();

//    print("[START] Fetching Summary");
    final response = await client.get(_apiUrl);

    final prefs = await SharedPreferences.getInstance();

//    print(response.body.toString());
    if (response.statusCode == 200) {
//      print("[DONE] Fetching Summary & Update Prefs");
      prefs.setString('summary', response.body);

      // If the call to the server was successful, parse the JSON
      return SummaryModel.fromJson(json.decode(response.body));
    } else {
      // print("[FAILED] Fetching Summary");
      // If that call was not successful, throw an error.
      throw Exception('Failed to load summary report');
    }
  }
}