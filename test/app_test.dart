import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/main.dart';

void main() {
  group('Pokedex App Tests', () {
    testWidgets('App should start without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const PokedexApp());

      // Verify that the app renders without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Should show loading or auth screen initially', (WidgetTester tester) async {
      await tester.pumpWidget(const PokedexApp());
      
      // Wait for any async operations
      await tester.pump();

      // Should show either a loading indicator or login screen
      final loadingFinder = find.byType(CircularProgressIndicator);
      final emailFinder = find.text('Email');
      
      expect(
        loadingFinder.evaluate().isNotEmpty || emailFinder.evaluate().isNotEmpty,
        isTrue,
      );
    });
  });
}
