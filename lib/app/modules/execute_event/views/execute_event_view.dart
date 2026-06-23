import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/rule.dart';
import '../controllers/execute_event_controller.dart';
import 'components/result_card.dart';

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
                    ResultCard(result: controller.result!),
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
