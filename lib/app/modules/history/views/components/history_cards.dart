import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/execution_record.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.record});
  final ExecutionRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasRules = record.triggeredRuleNames.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.4),
        ),
      ),
      child: Theme(
        // Cleans up the default expanding header divider line borders
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          maintainState: true,
          leading: CircleAvatar(
            backgroundColor: hasRules
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            child: Text(
              '${record.triggeredRuleNames.length}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: hasRules
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          title: Text(
            hasRules
                ? record.triggeredRuleNames.join(', ')
                : 'No rules triggered',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: hasRules
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat(
                    'dd MMM yyyy • hh:mm a',
                  ).format(record.executedAt.toLocal()),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          children: [
            const Divider(height: 16),
            const SizedBox(height: 8),

            // --- Event Payload Subsection ---
            Row(
              children: [
                Icon(
                  Icons.data_object,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Input Event Payload',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                ),
              ),
              child: Text(
                const JsonEncoder.withIndent('  ').convert(record.event),
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Triggered Actions Subsection ---
            Row(
              children: [
                Icon(Icons.bolt, size: 18, color: theme.colorScheme.secondary),
                const SizedBox(width: 6),
                Text(
                  'Triggered Actions',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: record.actions.isEmpty
                  ? Text(
                      'None',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: record.actions.map((action) {
                        return ChoiceChip(
                          label: Text(action['value']?.toString() ?? 'Unknown'),
                          selected: true,
                          selectedColor: theme.colorScheme.secondaryContainer,
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          onSelected: null,
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
