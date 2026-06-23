import 'package:get/get.dart';

import '../controllers/execute_event_controller.dart';

class ExecuteEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExecuteEventController>(
      () => ExecuteEventController(),
    );
  }
}
