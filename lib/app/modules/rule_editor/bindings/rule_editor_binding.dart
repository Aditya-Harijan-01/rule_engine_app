import 'package:get/get.dart';

import '../controllers/rule_editor_controller.dart';

class RuleEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RuleEditorController>(
      () => RuleEditorController(),
    );
  }
}
