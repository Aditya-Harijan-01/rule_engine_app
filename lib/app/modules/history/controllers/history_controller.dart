import 'package:get/get.dart';

import '../../../data/models/execution_record.dart';
import '../../../data/repositories/history_repository.dart';

class HistoryController extends GetxController {
  final _repository = HistoryRepository();

  // Reactive list of execution logs
  final records = <ExecutionRecord>[].obs;

  // Tracks your custom view loading/empty/success conditions automatically
  final status = RxStatus.loading().obs;

  @override
  void onInit() {
    super.onInit();
    // Bind directly to your repository stream
    status.value = RxStatus.loading();
    records.bindStream(_repository.watchAll());

    // Listen to stream updates to update state signals accordingly
    ever(
      records,
      (List<ExecutionRecord> data) {
        if (data.isEmpty) {
          status.value = RxStatus.empty();
        } else {
          status.value = RxStatus.success();
        }
      },
      onError: (err) {
        status.value = RxStatus.error(err.toString());
      },
    );
  }
}
