enum RuleOperator {
  equals('equals'),
  notEquals('does not equal'),
  greaterThan('is greater than'),
  lessThan('is less than'),
  contains('contains'),
  exists('exists');

  const RuleOperator(this.label);
  final String label;
}

class RuleCondition {
  const RuleCondition({
    required this.field,
    required this.operator,
    this.value,
  });
  final String field;
  final RuleOperator operator;
  final Object? value;

  Map<String, dynamic> toMap() => {
    'field': field,
    'operator': operator.name,
    'value': value,
  };
  factory RuleCondition.fromMap(Map<String, dynamic> map) => RuleCondition(
    field: map['field'] as String? ?? '',
    operator: RuleOperator.values.firstWhere(
      (e) => e.name == map['operator'],
      orElse: () => RuleOperator.greaterThan,
    ),
    value: map['value'],
  );
}

class RuleAction {
  const RuleAction({required this.type, required this.value});
  final String type;
  final String value;
  Map<String, dynamic> toMap() => {'type': type, 'value': value};
  factory RuleAction.fromMap(Map<String, dynamic> map) => RuleAction(
    type: map['type'] as String? ?? 'notification',
    value: map['value'] as String? ?? '',
  );
}

class BusinessRule {
  const BusinessRule({
    required this.id,
    required this.name,
    required this.conditions,
    required this.actions,
    required this.isActive,
    required this.priority,
  });
  final String id;
  final String name;
  final List<RuleCondition> conditions;
  final List<RuleAction> actions;
  final bool isActive;
  final int priority;

  BusinessRule copyWith({
    String? id,
    String? name,
    List<RuleCondition>? conditions,
    List<RuleAction>? actions,
    bool? isActive,
    int? priority,
  }) => BusinessRule(
    id: id ?? this.id,
    name: name ?? this.name,
    conditions: conditions ?? this.conditions,
    actions: actions ?? this.actions,
    isActive: isActive ?? this.isActive,
    priority: priority ?? this.priority,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'conditions': conditions.map((e) => e.toMap()).toList(),
    'actions': actions.map((e) => e.toMap()).toList(),
    'isActive': isActive,
    'priority': priority,
  };
  factory BusinessRule.fromMap(String id, Map<String, dynamic> map) =>
      BusinessRule(
        id: id,
        name: map['name'] as String? ?? 'Untitled rule',
        conditions: (map['conditions'] as List? ?? [])
            .map(
              (e) => RuleCondition.fromMap(Map<String, dynamic>.from(e as Map)),
            )
            .toList(),
        actions: (map['actions'] as List? ?? [])
            .map((e) => RuleAction.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
        isActive: map['isActive'] as bool? ?? false,
        priority: map['priority'] as int? ?? 0,
      );
}
