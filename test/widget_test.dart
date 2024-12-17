//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart'; // Ensure this path is correct

void main() {
  testWidgets('JokesApp has a title', (WidgetTester tester) async {
    await tester.pumpWidget(JokesApp());

    // Verify the app title
    expect(find.text('Jokes App'), findsOneWidget);
  });
}
