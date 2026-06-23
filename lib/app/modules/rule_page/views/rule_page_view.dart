// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/async_state.dart';
// import '../../../data/models/rule.dart';
// import '../../rule_editor/views/rule_editor_view.dart';
// import '../controllers/rule_page_controller.dart';

// class RulePageView extends GetView<RulePageController> {
//   const RulePageView({super.key});

//   Future<void> _openEditor(BuildContext context, [BusinessRule? rule]) async {
//     // Clean transition to your editor widget
//     final result = await Navigator.of(context).push<BusinessRule>(
//       MaterialPageRoute(builder: (_) => RuleEditorView(rule: rule)),
//     );
//     if (result != null) {
//       await controller.saveRule(result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Business Rules'), centerTitle: true),
//       body: StreamBuilder<List<BusinessRule>>(
//         stream: controller.repository.watchAll(),
//         builder: (context, snapshot) {
//           return AsyncStateView(
//             snapshot: snapshot,
//             builder: (rules) => Stack(
//               children: [
//                 if (rules.isEmpty)
//                   const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(32),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.rule_folder_outlined, size: 60),
//                           SizedBox(height: 12),
//                           Text(
//                             'No rules yet',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(height: 6),
//                           Text(
//                             'Create a rule to start automating events.',
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 else
//                   ListView.separated(
//                     padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
//                     itemCount: rules.length,
//                     separatorBuilder: (_, _) => const SizedBox(height: 10),
//                     itemBuilder: (_, i) {
//                       final rule = rules[i];
//                       return Card(
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.fromLTRB(
//                             16,
//                             8,
//                             8,
//                             8,
//                           ),
//                           title: Text(
//                             rule.name,
//                             style: const TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                           subtitle: Text(
//                             '${rule.conditions.length} condition${rule.conditions.length == 1 ? '' : 's'} • ${rule.actions.length} action${rule.actions.length == 1 ? '' : 's'}',
//                           ),
//                           onTap: () => _openEditor(context, rule),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Switch(
//                                 value: rule.isActive,
//                                 onChanged: (v) =>
//                                     controller.toggleActive(rule, v),
//                               ),
//                               PopupMenuButton<String>(
//                                 onSelected: (v) => v == 'edit'
//                                     ? _openEditor(context, rule)
//                                     : controller.deleteRule(rule),
//                                 itemBuilder: (_) => const [
//                                   PopupMenuItem(
//                                     value: 'edit',
//                                     child: Text('Edit'),
//                                   ),
//                                   PopupMenuItem(
//                                     value: 'delete',
//                                     child: Text('Delete'),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 Positioned(
//                   right: 20,
//                   bottom: 50,
//                   child: FloatingActionButton.extended(
//                     onPressed: () => _openEditor(context),
//                     icon: const Icon(Icons.add),
//                     label: const Text('New rule'),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/async_state.dart';
import '../../../data/models/rule.dart';
import '../../../routes/app_pages.dart';
import '../../rule_editor/views/rule_editor_view.dart';
import '../controllers/rule_page_controller.dart';

class RulePageView extends GetView<RulePageController> {
  const RulePageView({super.key});

  Future<void> openEditor(BuildContext context, {BusinessRule? rule}) async {
    final result = rule != null
        ? await Navigator.of(context).push<BusinessRule>(
            MaterialPageRoute(builder: (_) => RuleEditorView(rule: rule)),
          )
        : await Get.toNamed(Routes.RULE_EDITOR);

    if (result is BusinessRule) {
      await controller.saveRule(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Rules',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded, color: Color(0xFF5D5FEF)),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<List<BusinessRule>>(
        stream: controller.repository.watchAll(),
        builder: (context, snapshot) {
          return AsyncStateView(
            snapshot: snapshot,
            builder: (rules) => Column(
              children: [
                // Top Search and Add Row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search rules...',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF1F3F6),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () => openEditor(context),
                        icon: const Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Add Rule',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5D5FEF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Main List Layout View
                Expanded(
                  child: rules.isEmpty
                      ? const Center(child: Text('No rules configured yet.'))
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
                          itemCount: rules.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final rule = rules[i];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        rule.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: rule.isActive
                                            ? const Color(0xFFE8F5E9)
                                            : const Color(0xFFECEFF1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        rule.isActive ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          color: rule.isActive
                                              ? Colors.green.shade700
                                              : Colors.grey.shade700,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rule.conditions
                                            .map(
                                              (c) =>
                                                  '${c.field} ${c.operator.label} ${c.value ?? ""}',
                                            )
                                            .join(' AND '),
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        rule.actions
                                            .map((a) => a.value)
                                            .join(', '),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                  onSelected: (v) => v == 'edit'
                                      ? openEditor(context, rule: rule)
                                      : controller.deleteRule(rule),
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
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
          );
        },
      ),
    );
  }
}
