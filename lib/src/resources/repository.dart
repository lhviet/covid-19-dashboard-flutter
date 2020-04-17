import 'dart:async';

import 'summary_api_provider.dart';
import '../models/summary_model.dart';


class Repository {
  final summaryApiProvider = SummaryApiProvider();

  Future<SummaryModel> fetchSummary() => summaryApiProvider.fetchSummary();
}