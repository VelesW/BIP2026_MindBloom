import '../models/mood.dart';
import '../datasource/mood_remote_ds.dart';
import '../../services/mistral_service.dart';

class MoodRepository {
  final MoodRemoteDataSource remoteDataSource;
  final MistralService mistral;

  MoodRepository({required this.remoteDataSource, required this.mistral});

  /// Save a mood and return the created Mood object
  Future<Mood> saveMood({required String feeling}) async {
    final id = remoteDataSource.firestore.collection('moods').doc().id;

    // 🔥 Generate affirmation from Mistral
    final affirmation = await mistral.generateAffirmation(feeling);
    final mood = Mood(
      id: id,
      feeling: feeling,
      affirmation: affirmation,
      createdAt: DateTime.now(),
    );
    print("Saving mood: $feeling / $affirmation");
    await remoteDataSource.saveMood(mood);

    return mood;
  }

  /// Fetch last 10 moods (no user filtering)
  Future<List<Mood>> getLast10Moods() {
    return remoteDataSource.getLast10Moods();
  }
}
