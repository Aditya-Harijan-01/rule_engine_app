import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/rule.dart';
import '../controllers/rule_editor_controller.dart';

class RuleEditorView extends GetView<RuleEditorController> {
  final BusinessRule? rule;

  RuleEditorView({this.rule, super.key}) {
    Get.put(RuleEditorController(initialRule: rule));
  }

  @override
  RuleEditorController get controller => Get.find<RuleEditorController>();

  // Helper mapping helper to display custom decorative icons per operator variant
  IconData _getOperatorIcon(RuleOperator op) {
    switch (op) {
      case RuleOperator.equals:
        return Icons.drag_handle;
      case RuleOperator.exists:
        return Icons.visibility_outlined;
      // Add more cases here matching your actual RuleOperator enum values
      default:
        return Icons.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          rule == null ? 'Create Rule' : 'Edit Rule',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: controller.save,
              child: Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // --- General Configuration ---
            Text(
              'General Settings',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: 'Rule Name',
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: _required,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priority Dropdown Replace
                Expanded(
                  flex: 4,
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.priority.value,
                      decoration: const InputDecoration(
                        labelText: 'Priority Level',
                        prefixIcon: Icon(Icons.gavel_outlined),
                        helperText: 'Controls processing order',
                      ),
                      items: ['Low', 'Medium', 'High']
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => controller.priority.value = v!,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Active',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        value: controller.isActive.value,
                        onChanged: (v) => controller.isActive.value = v,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 16),

            // --- Conditions Section ---
            _SectionHeader(
              title: 'Conditions',
              subtitle: 'All conditions must match',
              icon: Icons.tune,
              onAdd: controller.addCondition,
            ),
            const SizedBox(height: 12),
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.conditions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildConditionCard(
                    context,
                    index,
                    controller.conditions[index],
                  );
                },
              ),
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 16),

            // --- Actions Section ---
            _SectionHeader(
              title: 'Actions',
              subtitle: 'Trigger operations sequentially',
              icon: Icons.flash_on,
              onAdd: controller.addAction,
            ),
            const SizedBox(height: 12),
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.actions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildActionCard(
                    context,
                    index,
                    controller.actions[index],
                  );
                },
              ),
            ),
            const SizedBox(height: 40),

            FilledButton.icon(
              onPressed: controller.save,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.save),
              label: const Text(
                'Save Rule Configuration',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionCard(
    BuildContext context,
    int index,
    ConditionDraft draft,
  ) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Condition Block',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (controller.conditions.length > 1)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () => controller.removeCondition(index),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: draft.field,
                  decoration: const InputDecoration(
                    labelText: 'Event Field',
                    hintText: 'e.g., amount or customer.tier',
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 16),

                // Operator Field with Added Embedded Leading Icons
                DropdownButtonFormField<RuleOperator>(
                  value: draft.operator,
                  decoration: const InputDecoration(labelText: 'Operator'),
                  items: RuleOperator.values
                      .map(
                        (o) => DropdownMenuItem(
                          value: o,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getOperatorIcon(o),
                                size: 18,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 10),
                              Text(o.label),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => controller.updateOperator(draft, v!),
                ),
                if (draft.operator != RuleOperator.exists) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: draft.value,
                    decoration: const InputDecoration(
                      labelText: 'Expected Value',
                    ),
                    validator: _required,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, int index, ActionDraft draft) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Action Step',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (controller.actions.length > 1)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    onPressed: () => controller.removeAction(index),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: draft.type,
                  decoration: const InputDecoration(labelText: 'Action Type'),
                  items:
                      const ['approval', 'escalation', 'assign', 'notification']
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Text(v.capitalizeFirst!),
                            ),
                          )
                          .toList(),
                  onChanged: (v) => controller.updateActionType(draft, v!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: draft.value,
                  decoration: const InputDecoration(
                    labelText: 'Action Value',
                    hintText: 'e.g., Require manager approval',
                  ),
                  validator: _required,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required.' : null;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onAdd,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../data/models/rule.dart';
// import '../controllers/rule_editor_controller.dart';

// class RuleEditorView extends GetView<RuleEditorController> {
//   final BusinessRule? rule;

//   RuleEditorView({this.rule, super.key}) {
//     Get.put(RuleEditorController(initialRule: rule));
//   }

//   @override
//   RuleEditorController get controller => Get.find<RuleEditorController>();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     final inputDecorationTheme = InputDecorationTheme(
//       filled: true,
//       fillColor: const Color(0xFFF8F9FA),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade200),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade200),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFF5D5FEF), width: 1.5),
//       ),
//     );

//     return Theme(
//       data: theme.copyWith(inputDecorationTheme: inputDecorationTheme),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () => Get.back(),
//           ),
//           title: Text(
//             rule == null ? 'Create Rule' : 'Edit Rule',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//           backgroundColor: Colors.white,
//           elevation: 0,
//           actions: [
//             TextButton(
//               onPressed: controller.save,
//               child: const Text(
//                 'Save',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: Color(0xFF5D5FEF),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//           ],
//         ),
//         body: Form(
//           key: controller.formKey,
//           child: ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             children: [
//               // Rule Name configuration block
//               const Text(
//                 'Rule Name',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: controller.nameController,
//                 decoration: const InputDecoration(
//                   hintText: 'e.g., High Expense Approval',
//                 ),
//                 validator: _required,
//               ),
//               const SizedBox(height: 18),

//               // Priority dropdown configuration field
//               const Text(
//                 'Priority Level',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Obx(
//                 () => DropdownButtonFormField<String>(
//                   value: controller.priority.value,
//                   items: ['Low', 'Medium', 'High']
//                       .map(
//                         (label) =>
//                             DropdownMenuItem(value: label, child: Text(label)),
//                       )
//                       .toList(),
//                   onChanged: (v) => controller.priority.value = v!,
//                 ),
//               ),
//               const SizedBox(height: 18),

//               // Status Active/Inactive field configuration
//               const Text(
//                 'Status',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Obx(
//                 () => DropdownButtonFormField<bool>(
//                   value: controller.isActive.value,
//                   items: const [
//                     DropdownMenuItem(value: true, child: Text('Active')),
//                     DropdownMenuItem(value: false, child: Text('Inactive')),
//                   ],
//                   onChanged: (v) => controller.isActive.value = v!,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // --- IF (Conditions Header row) ---
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'IF (Conditions)',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF5D5FEF),
//                       fontSize: 15,
//                     ),
//                   ),
//                   TextButton.icon(
//                     onPressed: controller.addCondition,
//                     icon: const Icon(
//                       Icons.add,
//                       size: 16,
//                       color: Color(0xFF5D5FEF),
//                     ),
//                     label: const Text(
//                       'Add',
//                       style: TextStyle(
//                         color: Color(0xFF5D5FEF),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Obx(
//                 () => ListView.separated(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: controller.conditions.length,
//                   separatorBuilder: (_, __) => const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 12.0),
//                     child: Divider(color: Color(0xFFF1F3F6), thickness: 2),
//                   ),
//                   itemBuilder: (context, index) {
//                     final draft = controller.conditions[index];
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Condition #${index + 1}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black54,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             if (controller.conditions.length > 1)
//                               GestureDetector(
//                                 onTap: () => controller.removeCondition(index),
//                                 child: const Text(
//                                   'Remove',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           'Field',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black54,
//                             fontSize: 13,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         TextFormField(
//                           controller: draft.field,
//                           decoration: const InputDecoration(
//                             hintText: 'e.g., amount',
//                           ),
//                           validator: _required,
//                         ),
//                         const SizedBox(height: 12),
//                         const Text(
//                           'Operator',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black54,
//                             fontSize: 13,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         DropdownButtonFormField<RuleOperator>(
//                           value: draft.operator,
//                           items: RuleOperator.values
//                               .map(
//                                 (o) => DropdownMenuItem(
//                                   value: o,
//                                   child: Text(o.label),
//                                 ),
//                               )
//                               .toList(),
//                           onChanged: (v) =>
//                               controller.updateOperator(draft, v!),
//                         ),
//                         if (draft.operator != RuleOperator.exists) ...[
//                           const SizedBox(height: 12),
//                           const Text(
//                             'Expected Value',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black54,
//                               fontSize: 13,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           TextFormField(
//                             controller: draft.value,
//                             decoration: const InputDecoration(
//                               hintText: 'e.g., 5000',
//                             ),
//                             validator: _required,
//                           ),
//                         ],
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 28),

//               // --- THEN (Actions Header row) ---
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'THEN (Actions)',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF5D5FEF),
//                       fontSize: 15,
//                     ),
//                   ),
//                   TextButton.icon(
//                     onPressed: controller.addAction,
//                     icon: const Icon(
//                       Icons.add,
//                       size: 16,
//                       color: Color(0xFF5D5FEF),
//                     ),
//                     label: const Text(
//                       'Add',
//                       style: TextStyle(
//                         color: Color(0xFF5D5FEF),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Obx(
//                 () => ListView.separated(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: controller.actions.length,
//                   separatorBuilder: (_, __) => const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 12.0),
//                     child: Divider(color: Color(0xFFF1F3F6), thickness: 2),
//                   ),
//                   itemBuilder: (context, index) {
//                     final draft = controller.actions[index];
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Action Step #${index + 1}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black54,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             if (controller.actions.length > 1)
//                               GestureDetector(
//                                 onTap: () => controller.removeAction(index),
//                                 child: const Text(
//                                   'Remove',
//                                   style: TextStyle(
//                                     color: Colors.red,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           'Action Type',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black54,
//                             fontSize: 13,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         DropdownButtonFormField<String>(
//                           value: draft.type,
//                           items:
//                               const [
//                                     'approval',
//                                     'escalation',
//                                     'assign',
//                                     'notification',
//                                   ]
//                                   .map(
//                                     (v) => DropdownMenuItem(
//                                       value: v,
//                                       child: Text(v.capitalizeFirst!),
//                                     ),
//                                   )
//                                   .toList(),
//                           onChanged: (v) =>
//                               controller.updateActionType(draft, v!),
//                         ),
//                         const SizedBox(height: 12),
//                         const Text(
//                           'Action Details Value',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black54,
//                             fontSize: 13,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         TextFormField(
//                           controller: draft.value,
//                           decoration: const InputDecoration(
//                             hintText: 'e.g., Require Manager Approval',
//                           ),
//                           validator: _required,
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String? _required(String? value) =>
//       value == null || value.trim().isEmpty ? 'Field required' : null;
// }
