import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/rule.dart';

class RuleEditorController extends GetxController {
  final BusinessRule? initialRule;
  RuleEditorController({this.initialRule});

  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;

  final priority = 'Medium'.obs;
  final isActive = true.obs;

  final conditions = <ConditionDraft>[].obs;
  final actions = <ActionDraft>[].obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: initialRule?.name ?? '');
    isActive.value = initialRule?.isActive ?? true;

    // Map numerical priority from DB to UI Dropdown string
    if (initialRule != null) {
      if (initialRule!.priority >= 10) {
        priority.value = 'High';
      } else if (initialRule!.priority <= 2) {
        priority.value = 'Low';
      } else {
        priority.value = 'Medium';
      }

      conditions.assignAll(
        initialRule!.conditions.map((c) => ConditionDraft.fromCondition(c)),
      );
      actions.assignAll(
        initialRule!.actions.map((a) => ActionDraft.fromAction(a)),
      );
    } else {
      priority.value = 'Medium';

      final condition = ConditionDraft();
      condition.field.text = 'amount';
      condition.value.text = '5000';

      conditions.add(condition);

      final action = ActionDraft();
      action.type = 'approval';
      action.value.text = 'Require Manager Approval';

      actions.add(action);
    }
  }

  int _getPriorityValue(String label) {
    switch (label) {
      case 'High':
        return 10;
      case 'Low':
        return 2;
      case 'Medium':
      default:
        return 5;
    }
  }

  void addCondition() => conditions.add(ConditionDraft());

  void removeCondition(int index) {
    if (conditions.length > 1) {
      conditions.removeAt(index).dispose();
    }
  }

  void addAction() => actions.add(ActionDraft());

  void removeAction(int index) {
    if (actions.length > 1) {
      actions.removeAt(index).dispose();
    }
  }

  void updateOperator(ConditionDraft draft, RuleOperator op) {
    draft.operator = op;
    conditions.refresh();
  }

  void updateActionType(ActionDraft draft, String type) {
    draft.type = type;
    actions.refresh();
  }

  void save() {
    if (!formKey.currentState!.validate()) return;

    // FIX: Generate a unique timestamp ID if this is a brand new rule
    final ruleId = initialRule?.id != null && initialRule!.id.isNotEmpty
        ? initialRule!.id
        : 'rule_${DateTime.now().millisecondsSinceEpoch}';

    final updatedRule = BusinessRule(
      id: ruleId,
      name: nameController.text.trim(),
      isActive: isActive.value,
      priority: _getPriorityValue(priority.value),
      conditions: conditions.map((d) => d.toCondition()).toList(),
      actions: actions.map((d) => d.toAction()).toList(),
    );

    Get.back(result: updatedRule);
  }

  @override
  void onClose() {
    nameController.dispose();
    for (var c in conditions) {
      c.dispose();
    }
    for (var a in actions) {
      a.dispose();
    }
    super.onClose();
  }
}

class ConditionDraft {
  final field = TextEditingController();
  final value = TextEditingController();
  RuleOperator operator = RuleOperator.greaterThan;

  ConditionDraft();

  ConditionDraft.fromCondition(RuleCondition c) {
    field.text = c.field;
    operator = c.operator;
    value.text = c.value?.toString() ?? '';
  }

  RuleCondition toCondition() => RuleCondition(
    field: field.text.trim(),
    operator: operator,
    value: operator == RuleOperator.exists ? null : _typed(value.text),
  );

  Object _typed(String v) =>
      num.tryParse(v) ??
      (v.toLowerCase() == 'true'
          ? true
          : (v.toLowerCase() == 'false' ? false : v.trim()));

  void dispose() {
    field.dispose();
    value.dispose();
  }
}

class ActionDraft {
  String type = 'notification';
  final value = TextEditingController();

  ActionDraft();

  ActionDraft.fromAction(RuleAction a) {
    type = a.type;
    value.text = a.value;
  }

  RuleAction toAction() => RuleAction(type: type, value: value.text.trim());
  void dispose() => value.dispose();
}
