import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/rule.dart';
import '../../../data/repositories/rule_engine.dart';
import '../controllers/execute_event_controller.dart';

class ExecuteEventView extends GetView<ExecuteEventController> {
  const ExecuteEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Execute Event'), centerTitle: true),
      // 1. Wrapped with GetBuilder to dynamically respond to changes in the controller
      body: GetBuilder<ExecuteEventController>(
        builder: (controller) {
          // 2. Listening to your Stream via StreamBuilder
          return StreamBuilder<List<BusinessRule>>(
            stream: controller.rulesRepository.watchAll(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Unable to load rules: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final rules = snapshot.data ?? const <BusinessRule>[];

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  Text(
                    'Event Payload',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  // TextField(
                  //   controller: controller.payloadController,
                  //   minLines: 7,
                  //   maxLines: 14,
                  //   style: const TextStyle(fontFamily: 'monospace'),
                  //   decoration: const InputDecoration(
                  //     hintText: '{\n  "type": "expense"\n}',
                  //   ),
                  // ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: controller.payloadController,
                      minLines: 8,
                      maxLines: 12,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (controller.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        controller.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: snapshot.hasData && !controller.running
                        ? () => controller.execute(rules)
                        : null,
                    icon: controller.running
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(
                      controller.running
                          ? 'Executing…'
                          : 'Execute ${rules.where((r) => r.isActive).length} active rules',
                    ),
                  ),
                  if (controller.result != null) ...[
                    const SizedBox(height: 24),
                    _ResultCard(result: controller.result!),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// Keeping the Presentation component decoupled and clean
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});
  final RuleExecutionResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  result.triggeredRules.isEmpty
                      ? Icons.info_outline
                      : Icons.check_circle,
                  color: result.triggeredRules.isEmpty ? null : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  result.triggeredRules.isEmpty
                      ? 'No rules triggered'
                      : '${result.triggeredRules.length} rule${result.triggeredRules.length == 1 ? '' : 's'} triggered',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            if (result.triggeredRules.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text(
                'Triggered rules',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...result.triggeredRules.map(
                (r) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.bolt, size: 20),
                  title: Text(r.name),
                  trailing: Text('P${r.priority}'),
                ),
              ),
              const Divider(),
              const Text(
                'Produced actions',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ...result.actions.map(
                (a) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.arrow_forward, size: 20),
                  title: Text(a.value),
                  subtitle: Text(a.type),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
