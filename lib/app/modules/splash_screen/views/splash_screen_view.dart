import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    // Inject controller if it hasn't been initialized by your bindings yet
    Get.put(SplashScreenController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // 1. App Icon Container
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xff7367f0), // Match purple brand color
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff7367f0).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  size: 72,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              // 2. Main Title text
              const Text(
                'Rule Engine',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),

              // 3. Subtitle description
              const Text(
                'Configure. Execute. Automate.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(flex: 2),

              // 4. Onboarding/Splash Page Indicators
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) => _buildDot(index)),
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  // Builder method for the custom indicator dot styling
  Widget _buildDot(int index) {
    final isSelected = controller.currentPage.value == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isSelected ? 24 : 8, // Pill shape if active, circle if inactive
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xff7367f0) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
