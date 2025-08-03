// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Correct import path for your main application file
import 'package:news_app/main.dart'; // Assuming your project name is 'news_app'

void main() {
  testWidgets('NewsApp renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Use the correct root widget for your application, which is NewsApp
    await tester.pumpWidget(const NewsApp());

    // Verify that the AppBar title 'Kaduna Polytechnic' is present
    expect(find.text('Kaduna Polytechnic'), findsOneWidget);

    // Verify that the 'Student News Hub' subtitle is present
    expect(find.textContaining('Student News Hub'), findsOneWidget);

    // Verify that the 'Urgent Announcements' banner is present
    expect(find.textContaining('Urgent Announcements'), findsOneWidget);

    // Verify that the 'Search news, announcements...' hint text is present
    expect(find.text('Search news, announcements...'), findsOneWidget);

    // Verify that the 'Filter by:' text is present
    expect(find.text('Filter by:'), findsOneWidget);

    // Verify that some filter chips are present (e.g., 'Administration')
    expect(find.byType(ChoiceChip), findsWidgets);
    expect(find.text('Administration'), findsOneWidget);

    // Verify that the 'Total Announcements' section is present
    expect(find.text('Total Announcements'), findsOneWidget);

    // You can add more specific tests here, for example:
    // - Tapping a filter chip and verifying the news list changes
    // - Verifying specific news item titles are displayed
  });
}
