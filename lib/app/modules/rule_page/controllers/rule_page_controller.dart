import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/rule.dart';
import '../../../data/repositories/rule_repository.dart';

class RulePageController extends GetxController {
  final repository = RuleRepository();

  Future<void> saveRule(BusinessRule rule) async {
    try {
      await repository.save(rule);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not save rule: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteRule(BusinessRule rule) async {
    // Show a native GetX dialog instead of boilerplate showDialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete rule?'),
        content: Text('“${rule.name}” will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await repository.delete(rule.id);
    }
  }

  Future<void> toggleActive(BusinessRule rule, bool isActive) async {
    await repository.setActive(rule, isActive);
  }
}
