import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tests_flutter/data/api_helper.dart';
import 'package:tests_flutter/pages/search_page.dart';

//* Given When Then

void main() {
  setUpAll(() async {
    HttpOverrides.global = _MyHttpOverrides();
  });

  //! Unit Test
  test(
      "GIVEN Trees as a query WHEN the API is called THEN check if we receive any data",
      () async {
    await getImageFromQuery("trees");
  });

  test(
      "GIVEN the curated API WHEN the API is called THEN check if we receive any data",
      () async {
    await getCuratedImages();
  });

  test(
      "GIVEN Trees as query WHEN data is added to stream THEN check if the value is received in Stream",
      () async {
    StreamSubscription subs = searchStream.stream.listen(null);
    subs.onData((data) {
      debugPrint("Received Data");
      subs.cancel();
    });
    await getImageFromQuery("trees");
    // Waiting for the Stream to take up event
    await addDelay(2000);
  });

  //! Widget Testing

  testWidgets(
      "GIVEN Trees as a query WHEN the query is made THEN Check if the images are loaded",
      (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(const MaterialApp(home: SearchPage()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), "Trees");
      await tester.tap(find.byType(IconButton));

      await addDelay(2000);
      await tester.pump();

      expect(find.byType(Image), findsWidgets);
    });
  });
}

class _MyHttpOverrides extends HttpOverrides {}

addDelay(int millis) async {
  await Future.delayed(Duration(milliseconds: millis));
}
