import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_models.dart';

class JournalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save a new entry to the user's specific collection
  Future<void> saveJournalEntry(String content) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception("User not authenticated");

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('journals')
        .add({
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Stream of journals so the UI updates in real-time
  Stream<List<JournalModel>> getJournalStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('journals')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => JournalModel.fromFirestore(doc)).toList();
    });
  }
}
