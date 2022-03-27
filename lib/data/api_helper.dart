import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../models/pexels_image.dart';
import '../models/pexels_search_result.dart';

//TODO: Place your authKey here
const String authKey = "yourkeyhere";
const String imageSearchUrl = "https://api.pexels.com/v1/search?query=";
const String curatedImageUrl = "https://api.pexels.com/v1/curated?per_page=20";

Future<void> getImageFromQuery(String query) async {
  debugPrint("Getting Image From Query $query");
  http.Response response = await http.get(
    Uri.parse(imageSearchUrl + query + "&per_page=20"),
    headers: {'Authorization': authKey},
  );

  PexelsSearchResult result = pexelsSearchResultFromJson(response.body);
  debugPrint(result.toString());

  searchStream.sink.add(result);
}

Future<List<PexelsImage>> getCuratedImages() async {
  debugPrint("Getting Curated Image");
  http.Response response = await http.get(
    Uri.parse(curatedImageUrl),
    headers: {'Authorization': authKey},
  );
  List list = json.decode(response.body)['photos'] as List;
  List<PexelsImage> imageList = list.map((e) {
    return PexelsImage.fromJson(e);
  }).toList();

  debugPrint(imageList.toString());
  return imageList;
}

StreamController<PexelsSearchResult> searchStream =
    StreamController.broadcast();
