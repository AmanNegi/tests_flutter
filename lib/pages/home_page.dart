import 'package:flutter/material.dart';
import 'package:tests_flutter/pages/search_page.dart';

import '../data/api_helper.dart';
import '../models/pexels_image.dart';
import 'full_screen_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Curated Images"),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        },
        child: const Icon(Icons.search),
      ),
      body: FutureBuilder(
        future: getCuratedImages(),
        builder: (context, AsyncSnapshot<List<PexelsImage>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return _getGridView(snapshot);
            } else {
              return const Center(child: Text("An Error Occured"));
            }
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  GridView _getGridView(AsyncSnapshot<List<PexelsImage>> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FullScreenImage(
                  imageUrl: snapshot.data![index].src.medium,
                ),
              ),
            );
          },
          child: Image.network(
            snapshot.data![index].src.medium,
            key: ValueKey(index),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
