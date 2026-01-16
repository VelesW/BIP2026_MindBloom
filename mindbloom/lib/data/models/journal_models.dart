import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class JournalModel extends Equatable {
  final String id;
  final String content;
  final DateTime createdAt;

  const JournalModel({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, content, createdAt];

  // Logic to convert Firestore data to our Model
  factory JournalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalModel(
      id: doc.id,
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Logic to convert our Model to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
