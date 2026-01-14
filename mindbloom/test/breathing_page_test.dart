import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starseu/pages/breathing_page.dart';

void main() {
  testWidgets('BreathingPage initial state test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: BreathExercisePage(),
    ));

    // Verify that the initial UI elements are present.
    expect(find.text('Breathing Exercise'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
