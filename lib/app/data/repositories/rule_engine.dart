import 'package:flutter/foundation.dart';

import '../models/rule.dart';

class RuleExecutionResult {
  const RuleExecutionResult({
    required this.triggeredRules,
    required this.actions,
  });
  final List<BusinessRule> triggeredRules;
  final List<RuleAction> actions;
}

class RuleEngine {
  const RuleEngine();

  RuleExecutionResult execute(
    List<BusinessRule> rules,
    Map<String, dynamic> event,
  ) {
    if (kDebugMode) {
      print('====================================');
      print('EVENT PAYLOAD');
      print(event);
      print('TOTAL RULES: ${rules.length}');
      print('====================================');
    }

    final ordered = rules.where((r) => r.isActive).toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));

    if (kDebugMode) {
      print('ACTIVE RULES: ${ordered.length}');
    }

    final triggered = <BusinessRule>[];

    for (final rule in ordered) {
      if (kDebugMode) {
        print('\n------------------------------------');
        print('Checking Rule: ${rule.name}');
        print('Priority: ${rule.priority}');
        print('Active: ${rule.isActive}');
        print('Conditions Count: ${rule.conditions.length}');
        print('------------------------------------');
      }

      bool matched = true;

      for (final condition in rule.conditions) {
        final actual = _readPath(event, condition.field);

        if (kDebugMode) {
          print('Field      : ${condition.field}');
          print('Operator   : ${condition.operator.name}');
          print('Expected   : ${condition.value}');
          print('Actual     : $actual');
        }

        final result = _matches(condition, event);

        if (kDebugMode) {
          print('Match      : $result');
        }

        if (!result) {
          matched = false;
          break;
        }
      }

      if (kDebugMode) {
        print('RULE RESULT: $matched');
      }

      if (matched && rule.conditions.isNotEmpty) {
        triggered.add(rule);
      }
    }

    if (kDebugMode) {
      print('\n====================================');
      print('TRIGGERED RULES: ${triggered.length}');
      print(triggered.map((e) => e.name).toList());
      print('====================================');
    }

    return RuleExecutionResult(
      triggeredRules: triggered,
      actions: triggered.expand((rule) => rule.actions).toList(),
    );
  }

  bool _matches(RuleCondition condition, Map<String, dynamic> event) {
    final actual = _readPath(event, condition.field);
    final expected = condition.value;

    switch (condition.operator) {
      case RuleOperator.exists:
        return actual != null;

      case RuleOperator.equals:
        return _normalized(actual) == _normalized(expected);

      case RuleOperator.notEquals:
        return _normalized(actual) != _normalized(expected);

      case RuleOperator.greaterThan:
        final actualNum = _number(actual);
        final expectedNum = _number(expected);

        print('Actual Number   : $actualNum');
        print('Expected Number : $expectedNum');

        return actualNum != null &&
            expectedNum != null &&
            actualNum > expectedNum;

      case RuleOperator.lessThan:
        final actualNum = _number(actual);
        final expectedNum = _number(expected);

        print('Actual Number   : $actualNum');
        print('Expected Number : $expectedNum');

        return actualNum != null &&
            expectedNum != null &&
            actualNum < expectedNum;

      case RuleOperator.contains:
        if (actual is List) {
          return actual
              .map((e) => _normalized(e))
              .contains(_normalized(expected));
        }

        return actual?.toString().toLowerCase().contains(
              expected?.toString().toLowerCase() ?? '',
            ) ??
            false;
    }
  }

  Object? _readPath(Map<String, dynamic> event, String path) {
    Object? current = event;

    for (final part in path.split('.')) {
      if (current is! Map) {
        print('Path Error: "$part" not found');
        return null;
      }

      current = current[part];
    }

    return current;
  }

  Object? _normalized(Object? value) {
    if (value == null) return null;

    if (value is String) {
      return value.trim().toLowerCase();
    }

    return value.toString().trim().toLowerCase();
  }

  num? _number(Object? value) {
    if (value is num) return value;

    return num.tryParse(value?.toString() ?? '');
  }
}
