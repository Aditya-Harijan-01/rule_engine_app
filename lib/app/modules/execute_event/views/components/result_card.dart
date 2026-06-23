// Keeping the Presentation component decoupled and clean
import 'package:flutter/material.dart';

import '../../../../data/repositories/rule_engine.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.result});
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
