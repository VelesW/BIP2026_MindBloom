import 'package:equatable/equatable.dart';

class Mood extends Equatable {
  final String id;
  final String feeling;
  final String affirmation;
  final DateTime createdAt;

  const Mood({
    required this.id,
    required this.feeling,
    required this.affirmation,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, feeling, affirmation, createdAt];

  Map<String, dynamic> toMap() => {
    'id': id,
    'feeling': feeling,
    'affirmation': affirmation,
    'createdAt': createdAt.toUtc().millisecondsSinceEpoch,
  };

  factory Mood.fromMap(Map<String, dynamic> map) => Mood(
    id: map['id'] as String,
    feeling: map['feeling'] as String,
    affirmation: map['affirmation'] as String,
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      (map['createdAt'] as int),
      isUtc: true,
    ).toLocal(),
  );
}
