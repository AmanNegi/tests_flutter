import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tests_flutter/data/api_helper.dart';
import 'package:tests_flutter/models/pexels_image.dart';
import 'package:tests_flutter/pages/search_page.dart';

//* Given When Then

void main() {
  setUpAll(() async {
    HttpOverrides.global = _MyHttpOverrides();
  });

  //! Unit Test
  test(
      "Check if the RandomImages API and JSON to model conversion is working fine",
      () async {
    List<PexelsImage> imagesList;
    imagesList = await getCuratedImages();
    expect(imagesList, isNotNull);
  });

  test(
      "When given Trees as query to the Search Image function check if any output is printed",
      () async {
    await getImageFromQuery("trees");
  });

  test(
      "When trees images are searched check if values are received in the stream",
      () async {
    StreamSubscription subs = searchStream.stream.listen(null);
    subs.onData((data) {
      debugPrint("Received Data");
      expect(data, isNotNull);
      subs.cancel();
    });
    await getImageFromQuery("trees");
    // Waiting for the Stream to take up event
    await addDelay(2000);
  });

  //! Widget Testing

  testWidgets("When given trees as query check if the images are loaded",
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
