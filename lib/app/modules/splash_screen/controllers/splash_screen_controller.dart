import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  // Current page index for the onboarding/splash dot indicator
  final currentPage = 0.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Simulate a 3-second splash delay, then navigate to your main view
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    bool isLoggedIn = box.read('isLogin') ?? false;
    if (isLoggedIn) {
      Get.offAllNamed(Routes.HOME); // Navigate to home if already logged in
    } else {
      Get.offAllNamed(
        Routes.AUTH_PAGE,
      ); // Navigate to auth page if not logged in
    }
    // Replace '/rules' with whatever your target route name is
    // Get.offNamed('/rules');
  }
}
