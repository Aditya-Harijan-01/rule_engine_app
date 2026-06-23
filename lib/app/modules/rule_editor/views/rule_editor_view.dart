import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/rule.dart';
import '../controllers/rule_editor_controller.dart';

class RuleEditorView extends GetView<RuleEditorController> {
  final BusinessRule? rule;

  RuleEditorView({this.rule, super.key}) {
    if (Get.isRegistered<RuleEditorController>()) {
      try {
        Get.delete<RuleEditorController>(force: true);
      } catch (_) {}
    }
    Get.put(RuleEditorController(initialRule: rule));
  }

  @override
  RuleEditorController get controller => Get.find<RuleEditorController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF5D5FEF), width: 1.5),
      ),
    );

    return Theme(
      data: theme.copyWith(inputDecorationTheme: inputDecorationTheme),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: Text(
            rule == null ? 'Create Rule' : 'Edit Rule',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: controller.save,
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF5D5FEF),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // Rule Name configuration block
              const Text(
                'Rule Name',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g., High Expense Approval',
                ),
                validator: _required,
              ),
              const SizedBox(height: 18),

              // Priority dropdown configuration field
              const Text(
                'Priority Level',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.priority.value,
                  items: ['Low', 'Medium', 'High']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (v) => controller.priority.value = v!,
                ),
              ),
              const SizedBox(height: 18),

              // Status Active/Inactive field configuration
              const Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<bool>(
                  value: controller.isActive.value,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Active')),
                    DropdownMenuItem(value: false, child: Text('Inactive')),
                  ],
                  onChanged: (v) => controller.isActive.value = v!,
                ),
              ),
              const SizedBox(height: 24),

              // --- IF (Conditions Header row) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'IF (Conditions)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D5FEF),
                      fontSize: 15,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: controller.addCondition,
                    icon: const Icon(
                      Icons.add,
                      size: 16,
                      color: Color(0xFF5D5FEF),
                    ),
                    label: const Text(
                      'Add',
                      style: TextStyle(
                        color: Color(0xFF5D5FEF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.conditions.length,
                  separatorBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Color(0xFFF1F3F6), thickness: 2),
                  ),
                  itemBuilder: (context, index) {
                    final draft = controller.conditions[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Condition #${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            if (controller.conditions.length > 1)
                              GestureDetector(
                                onTap: () => controller.removeCondition(index),
                                child: const Text(
                                  'Remove',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Field',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: draft.field,
                          decoration: const InputDecoration(
                            hintText: 'e.g., amount',
                          ),
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Operator',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<RuleOperator>(
                          value: draft.operator,
                          items: RuleOperator.values
                              .map(
                                (o) => DropdownMenuItem(
                                  value: o,
                                  child: Text(o.label),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              controller.updateOperator(draft, v!),
                        ),
                        if (draft.operator != RuleOperator.exists) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Expected Value',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: draft.value,
                            decoration: const InputDecoration(
                              hintText: 'e.g., 5000',
                            ),
                            validator: _required,
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              // --- THEN (Actions Header row) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'THEN (Actions)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D5FEF),
                      fontSize: 15,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: controller.addAction,
                    icon: const Icon(
                      Icons.add,
                      size: 16,
                      color: Color(0xFF5D5FEF),
                    ),
                    label: const Text(
                      'Add',
                      style: TextStyle(
                        color: Color(0xFF5D5FEF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.actions.length,
                  separatorBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Color(0xFFF1F3F6), thickness: 2),
                  ),
                  itemBuilder: (context, index) {
                    final draft = controller.actions[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Action Step #${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            if (controller.actions.length > 1)
                              GestureDetector(
                                onTap: () => controller.removeAction(index),
                                child: const Text(
                                  'Remove',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Action Type',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: draft.type,
                          items:
                              const [
                                    'approval',
                                    'escalation',
                                    'assign',
                                    'notification',
                                  ]
                                  .map(
                                    (v) => DropdownMenuItem(
                                      value: v,
                                      child: Text(v.capitalizeFirst!),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) =>
                              controller.updateActionType(draft, v!),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Action Details Value',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: draft.value,
                          decoration: const InputDecoration(
                            hintText: 'e.g., Require Manager Approval',
                          ),
                          validator: _required,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Field required' : null;
}
