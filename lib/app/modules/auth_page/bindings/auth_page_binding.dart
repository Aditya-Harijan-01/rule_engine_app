import 'package:get/get.dart';

import '../controllers/auth_page_controller.dart';

class AuthPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthPageController>(
      () => AuthPageController(),
    );
  }
}
