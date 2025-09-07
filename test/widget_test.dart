import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:swim360_app/main.dart';

void main() {
  testWidgets('App displays welcome message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app shows the welcome message.
    expect(find.text('Welcome to Swim360!'), findsOneWidget);

    // Verify that the counter is NOT present.
    expect(find.text('0'), findsNothing);
    expect(find.byIcon(Icons.add), findsNothing);
  });
}