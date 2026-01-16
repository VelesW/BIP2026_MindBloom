import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mood.dart';

class MoodRemoteDataSource {
  final FirebaseFirestore firestore;

  MoodRemoteDataSource({required this.firestore});

  /// Save a mood entry to Firestore
  Future<void> saveMood(Mood mood) async {
    await firestore.collection('moods').doc(mood.id).set(mood.toMap());
  }

  /// Fetch the last 10 moods
  Future<List<Mood>> getLast10Moods() async {
    final snapshot = await firestore
        .collection('moods')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => Mood.fromMap(doc.data())).toList();
  }
}
