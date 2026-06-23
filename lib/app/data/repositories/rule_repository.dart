import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/rule.dart';

class RuleRepository {
  RuleRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _rules {
    final user = _auth.currentUser;
    if (user == null) throw StateError('A signed-in user is required.');
    return _firestore.collection('users').doc(user.uid).collection('rules');
  }

  Stream<List<BusinessRule>> watchAll() => _rules.snapshots().map((snapshot) {
    final rules = snapshot.docs
        .map((d) => BusinessRule.fromMap(d.id, d.data()))
        .toList();
    rules.sort((a, b) => b.priority.compareTo(a.priority));
    return rules;
  });

  Future<void> save(BusinessRule rule) async {
    final data = {...rule.toMap(), 'updatedAt': FieldValue.serverTimestamp()};
    if (rule.id.isEmpty) {
      await _rules.add({...data, 'createdAt': FieldValue.serverTimestamp()});
    } else {
      await _rules.doc(rule.id).set(data, SetOptions(merge: true));
    }
  }

  Future<void> delete(String id) => _rules.doc(id).delete();
  Future<void> setActive(BusinessRule rule, bool value) => _rules
      .doc(rule.id)
      .update({'isActive': value, 'updatedAt': FieldValue.serverTimestamp()});
}
