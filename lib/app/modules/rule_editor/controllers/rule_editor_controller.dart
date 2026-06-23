import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/rule.dart';

class RuleEditorController extends GetxController {
  //   final BusinessRule? initialRule;

  //   RuleEditorController({this.initialRule});

  //   final formKey = GlobalKey<FormState>();

  //   late TextEditingController nameController;
  //   late TextEditingController priorityController;

  //   // Reactive fields for simple view states
  //   final isActive = true.obs;

  //   // Reactive list objects holding temporary drafts
  //   final conditions = <ConditionDraft>[].obs;
  //   final actions = <ActionDraft>[].obs;

  //   // 1. Inside your RuleEditorController class:
  // // Change your priority controller to a reactive String variable
  // final priority = 'Medium'.obs;

  // // @override
  // // void onInit() {
  // //   super.onInit();
  // //   nameController = TextEditingController(text: initialRule?.name ?? '');

  // //   // Map incoming database priority integer to readable labels
  // //   if (initialRule != null) {
  // //     if (initialRule!.priority >= 10) {
  // //       priority.value = 'High';
  // //     } else if (initialRule!.priority <= 2) {
  // //       priority.value = 'Low';
  // //     } else {
  // //       priority.value = 'Medium';
  // //     }
  // //   } else {
  // //     priority.value = 'Medium';
  // //   }

  // //   // ... rest of your existing initialization code
  // // }

  // // 2. Inside your controller's save() method, map the text labels back to system integers:
  // int getPriorityValue(String label) {
  //   switch (label) {
  //     case 'High': return 10;
  //     case 'Low': return 2;
  //     case 'Medium':
  //     default:
  //       return 5;
  //   }
  // }

  // // Then replace `priority: int.parse(priorityController.text)` with:
  // // priority: _getPriorityValue(priority.value),

  //   @override
  //   void onInit() {
  //     super.onInit();
  //     nameController = TextEditingController(text: initialRule?.name ?? '');
  //     priorityController = TextEditingController(
  //       text: '${initialRule?.priority ?? 0}',
  //     );
  //     isActive.value = initialRule?.isActive ?? true;

  //     if (initialRule != null) {
  //       conditions.assignAll(
  //         initialRule!.conditions.map((c) => ConditionDraft.fromCondition(c)),
  //       );
  //       actions.assignAll(
  //         initialRule!.actions.map((a) => ActionDraft.fromAction(a)),
  //       );
  //     } else {
  //       conditions.add(ConditionDraft());
  //       actions.add(ActionDraft());
  //     }
  //   }

  //   void addCondition() => conditions.add(ConditionDraft());

  //   void removeCondition(int index) {
  //     if (conditions.length > 1) {
  //       conditions.removeAt(index).dispose();
  //     }
  //   }

  //   void addAction() => actions.add(ActionDraft());

  //   void removeAction(int index) {
  //     if (actions.length > 1) {
  //       actions.removeAt(index).dispose();
  //     }
  //   }

  //   void updateOperator(ConditionDraft draft, RuleOperator op) {
  //     draft.operator = op;
  //     conditions.refresh(); // Triggers update for sub-items
  //   }

  //   void updateActionType(ActionDraft draft, String type) {
  //     draft.type = type;
  //     actions.refresh();
  //   }

  //   void save() {
  //     if (!formKey.currentState!.validate()) return;

  //     final updatedRule = BusinessRule(
  //       id: initialRule?.id ?? '',
  //       name: nameController.text.trim(),
  //       isActive: isActive.value,
  //       priority: int.parse(priorityController.text),
  //       conditions: conditions.map((d) => d.toCondition()).toList(),
  //       actions: actions.map((d) => d.toAction()).toList(),
  //     );

  //     Get.back(result: updatedRule);
  //   }

  //   @override
  //   void onClose() {
  //     nameController.dispose();
  //     priorityController.dispose();
  //     for (var c in conditions) {
  //       c.dispose();
  //     }
  //     for (var a in actions) {
  //       a.dispose();
  //     }
  //     super.onClose();
  //   }
  // }

  // class ConditionDraft {
  //   final field = TextEditingController();
  //   final value = TextEditingController();
  //   RuleOperator operator = RuleOperator.equals;

  //   ConditionDraft();

  //   ConditionDraft.fromCondition(RuleCondition c) {
  //     field.text = c.field;
  //     operator = c.operator;
  //     value.text = c.value?.toString() ?? '';
  //   }

  //   RuleCondition toCondition() => RuleCondition(
  //     field: field.text.trim(),
  //     operator: operator,
  //     value: operator == RuleOperator.exists ? null : _typed(value.text),
  //   );

  //   Object _typed(String v) =>
  //       num.tryParse(v) ??
  //       (v.toLowerCase() == 'true'
  //           ? true
  //           : (v.toLowerCase() == 'false' ? false : v.trim()));

  //   void dispose() {
  //     field.dispose();
  //     value.dispose();
  //   }
  // }

  // class ActionDraft {
  //   String type = 'notification';
  //   final value = TextEditingController();

  //   ActionDraft();

  //   ActionDraft.fromAction(RuleAction a) {
  //     type = a.type;
  //     value.text = a.value;
  //   }

  //   RuleAction toAction() => RuleAction(type: type, value: value.text.trim());
  //   void dispose() => value.dispose();
  // }

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
      conditions.add(ConditionDraft());
      actions.add(ActionDraft());
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
  RuleOperator operator = RuleOperator.equals;

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
