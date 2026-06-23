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
    final ordered = rules.where((r) => r.isActive).toList()
      ..sort((a, b) => b.priority.compareTo(a.priority));
    final triggered = ordered
        .where(
          (rule) =>
              rule.conditions.isNotEmpty &&
              rule.conditions.every((condition) => _matches(condition, event)),
        )
        .toList();
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
        return _number(actual) != null &&
            _number(expected) != null &&
            _number(actual)! > _number(expected)!;
      case RuleOperator.lessThan:
        return _number(actual) != null &&
            _number(expected) != null &&
            _number(actual)! < _number(expected)!;
      case RuleOperator.contains:
        if (actual is List)
          return actual.map(_normalized).contains(_normalized(expected));
        return actual?.toString().toLowerCase().contains(
              expected?.toString().toLowerCase() ?? '',
            ) ??
            false;
    }
  }

  Object? _readPath(Map<String, dynamic> event, String path) {
    Object? current = event;
    for (final part in path.split('.')) {
      if (current is! Map) return null;
      current = current[part];
    }
    return current;
  }

  Object? _normalized(Object? value) =>
      value is String ? value.trim().toLowerCase() : value;
  num? _number(Object? value) =>
      value is num ? value : num.tryParse(value?.toString() ?? '');
}
