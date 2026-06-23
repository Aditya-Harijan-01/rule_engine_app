import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final name = box.read('userEmail');
    final cards = [
      {
        'title': 'Rules',
        'subtitle': 'Manage your rules',
        'icon': Icons.verified_user_outlined,
        'color': Colors.deepPurple,
      },
      {
        'title': 'Execute Event',
        'subtitle': 'Run rules on events',
        'icon': Icons.cached_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'History',
        'subtitle': 'View execution history',
        'icon': Icons.shield_outlined,
        'color': Colors.green,
      },
      {
        'title': 'Logout',
        'subtitle': 'Sign out of your account',
        'icon': Icons.logout,
        'color': Colors.orange,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Text(
                'Hello, $name 👋',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                'What would you like to do?',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final item = cards[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        switch (item['title']) {
                          case 'Rules':
                            Get.toNamed(Routes.RULE_PAGE);
                            break;
                          case 'Execute Event':
                            Get.toNamed(Routes.EXECUTE_EVENT);
                            break;
                          case 'History':
                            Get.toNamed(Routes.HISTORY);
                            break;
                          case 'Logout':
                            // Get.toNamed(Routes.PROFILE);
                            box.erase();
                            Get.offAllNamed(Routes.AUTH_PAGE);
                            break;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (item['color'] as Color).withOpacity(
                                  0.15,
                                ),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: item['color'] as Color,
                                size: 26,
                              ),
                            ),

                            const Spacer(),

                            Text(
                              item['title'] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              item['subtitle'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
