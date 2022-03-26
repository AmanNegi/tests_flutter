import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:tests_flutter/main.dart' as app;
import 'package:tests_flutter/pages/home_page.dart';
import 'package:tests_flutter/pages/search_page.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }
  group("end to end test", () {
    testWidgets("Test to Check the Curated Page Flow", (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));
      await tester.pumpAndSettle();
      addDelay(1000);

      await tester.tap(find.byKey(const ValueKey(0)));
      await tester.pumpAndSettle();
      addDelay(1000);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      addDelay(1000);

      expect(find.byType(TextField), findsOneWidget);
    });
    testWidgets("Test to Check the Search Page flow", (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchPage(),
        ),
      );
      await tester.pumpAndSettle();

      await addDelay(2000);
      await tester.enterText(find.byType(TextField), "Trees");
      await tester.tap(find.byType(IconButton));

      await addDelay(2000);
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsWidgets);
      await addDelay(2000);

      var finder = find.byKey(const ValueKey(0));
      Image parentImage = tester.widget(finder);

      await tester.tap(finder);
      await tester.pumpAndSettle();

      Image img = tester.widget(find.byType(Image));
      expect(parentImage.image, img.image);
    });
  });
}

addDelay(int millis) async {
  await Future.delayed(Duration(milliseconds: millis));
}
