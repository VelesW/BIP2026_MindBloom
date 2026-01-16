import 'package:equatable/equatable.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object?> get props => [];
}

class LoadJournals extends JournalEvent {}

class AddJournalEntry extends JournalEvent {
  final String content;

  const AddJournalEntry(this.content);

  @override
  List<Object?> get props => [content];
}
