import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/journal/journal_bloc.dart';
import '../../bloc/journal/journal_event.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("My Journal")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "What are you grateful for today?",
                  border: InputBorder.none,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<JournalBloc>().add(AddJournalEntry(controller.text));
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Entry"),
            ),
          ],
        ),
      ),
    );
  }
}
