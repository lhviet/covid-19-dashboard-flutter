import 'package:rxdart/rxdart.dart';

import '../models/summary_model.dart';
import '../resources/repository.dart';

class SummaryBloc {
  final _repository = Repository();
  final _summaryFetcher = PublishSubject<SummaryModel>();

  Stream<SummaryModel> get summary => _summaryFetcher.stream;

  fetchSummary() async {
    SummaryModel itemModel = await _repository.fetchSummary();
    _summaryFetcher.sink.add(itemModel);
  }

  dispose() {
    _summaryFetcher.close();
  }
}

final bloc = SummaryBloc();