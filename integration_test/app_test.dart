import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tests_flutter/pages/home_page.dart';
import 'package:tests_flutter/pages/search_page.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }
  testWidgets("Test to Check the Curated Page Flow", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();
    addDelay(2000);

    // Open the Image in Full Screen
    await tester.tap(find.byKey(const ValueKey(0)));
    await tester.pumpAndSettle();
    addDelay(1000);

    // Go Back to HomePage
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Go to Search Page
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    addDelay(1000);
 
    // Assert to check we are on the right page
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), "Trees");
    await tester.tap(find.byKey(SearchPage.searchIconButtonKey));

    addDelay(2000);
    await tester.pumpAndSettle();

    // Assert that we get Results
    expect(find.byType(Image), findsWidgets);

    addDelay(2000);
  });
}

addDelay(int millis) async {
  await Future.delayed(Duration(milliseconds: millis));
}
