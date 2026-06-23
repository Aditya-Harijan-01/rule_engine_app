import 'package:get/get.dart';

import '../controllers/rule_page_controller.dart';

class RulePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RulePageController>(
      () => RulePageController(),
    );
  }
}
