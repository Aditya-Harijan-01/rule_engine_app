import 'package:cloud_firestore/cloud_firestore.dart';

class ExecutionRecord {
  const ExecutionRecord({
    required this.id,
    required this.event,
    required this.triggeredRuleNames,
    required this.actions,
    required this.executedAt,
    required this.success,
  });
  final String id;
  final Map<String, dynamic> event;
  final List<String> triggeredRuleNames;
  final List<Map<String, dynamic>> actions;
  final DateTime executedAt;
  final bool success;

  factory ExecutionRecord.fromMap(String id, Map<String, dynamic> map) =>
      ExecutionRecord(
        id: id,
        event: Map<String, dynamic>.from(map['event'] as Map? ?? {}),
        triggeredRuleNames: List<String>.from(
          map['triggeredRuleNames'] as List? ?? [],
        ),
        actions: (map['actions'] as List? ?? [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList(),
        executedAt:
            (map['executedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        success: map['success'] as bool? ?? true,
      );
}
