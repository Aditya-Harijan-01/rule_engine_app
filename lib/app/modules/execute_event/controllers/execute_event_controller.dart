import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/rule.dart';
import '../../../data/repositories/history_repository.dart';
import '../../../data/repositories/rule_engine.dart';
import '../../../data/repositories/rule_repository.dart';

class ExecuteEventController extends GetxController {
  // 1. Made the controller private or accessible depending on your UI needs
  final payloadController = TextEditingController(
    text: const JsonEncoder.withIndent(
      '  ',
    ).convert({'type': 'expense', 'amount': 7000}),
  );

  final rulesRepository = RuleRepository();
  final historyRepository = HistoryRepository();
  final engine = const RuleEngine();

  // 2. State variables (You can make these Rx if you want reactive UI,
  // but standard variables work perfectly fine with update())
  String? error;
  RuleExecutionResult? result;
  bool running = false;

  // 3. GetX controllers use onClose() instead of dispose() for resource cleanup
  @override
  void onClose() {
    payloadController.dispose();
    super.onClose();
  }

  Future<void> execute(List<BusinessRule> rules) async {
    error = null;
    result = null;
    running = true;
    update(); // Notifies the GetBuilder to show the loading state

    try {
      final decoded = jsonDecode(payloadController.text);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Payload must be a JSON object.');
      }

      // Fixed: changed _engine and _history to match declared variable names
      result = engine.execute(rules, decoded);
      await historyRepository.add(decoded, result!);
    } on FormatException catch (e) {
      error = 'Invalid JSON: ${e.message}';
    } catch (e) {
      error = 'Execution failed: $e';
    } finally {
      running = false;
      update(); // Notifies the GetBuilder to refresh the UI with the results/errors
    }
  }
}
