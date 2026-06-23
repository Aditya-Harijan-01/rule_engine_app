import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/execution_record.dart';
import 'rule_engine.dart';

class HistoryRepository {
  HistoryRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _history {
    final user = _auth.currentUser;
    if (user == null) throw StateError('A signed-in user is required.');
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('executions');
  }

  Stream<List<ExecutionRecord>> watchAll() => _history
      .orderBy('executedAt', descending: true)
      .limit(100)
      .snapshots()
      .map(
        (s) =>
            s.docs.map((d) => ExecutionRecord.fromMap(d.id, d.data())).toList(),
      );

  Future<void> add(Map<String, dynamic> event, RuleExecutionResult result) =>
      _history.add({
        'event': event,
        'triggeredRuleIds': result.triggeredRules.map((r) => r.id).toList(),
        'triggeredRuleNames': result.triggeredRules.map((r) => r.name).toList(),
        'actions': result.actions.map((a) => a.toMap()).toList(),
        'success': true,
        'executedAt': FieldValue.serverTimestamp(),
      });
}
