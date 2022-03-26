import 'dart:convert';

import 'package:tests_flutter/models/pexels_image.dart';

PexelsSearchResult pexelsSearchResultFromJson(String str) =>
    PexelsSearchResult.fromJson(json.decode(str));

String pexelsSearchResultToJson(PexelsSearchResult data) =>
    json.encode(data.toJson());

class PexelsSearchResult {
  PexelsSearchResult({
    required this.totalResults,
    required this.page,
    required this.perPage,
    required this.photos,
    required this.nextPage,
  });

  int totalResults;
  int page;
  int perPage;
  List<PexelsImage> photos;
  String nextPage;

  factory PexelsSearchResult.fromJson(Map<String, dynamic> json) =>
      PexelsSearchResult(
        totalResults: json["total_results"],
        page: json["page"],
        perPage: json["per_page"],
        photos: List<PexelsImage>.from(
            json["photos"].map((x) => PexelsImage.fromJson(x))),
        nextPage: json["next_page"],
      );

  Map<String, dynamic> toJson() => {
        "total_results": totalResults,
        "page": page,
        "per_page": perPage,
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "next_page": nextPage,
      };

  @override
  String toString() {
    return "PexelsSearchResult(totalResults: $totalResults, photos:${photos.toString()}, perPage: $perPage)";
  }
}
