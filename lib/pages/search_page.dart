import 'package:flutter/material.dart';

import '../data/api_helper.dart';
import '../models/pexels_search_result.dart';
import 'full_screen_image.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const Key searchIconButtonKey = ValueKey("IconButton01");
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchTextFieldController = TextEditingController();
  bool isSearching = false;

  @override
  void dispose() {
    searchTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Search Page"),
      ),
      body: Column(
        children: [
          Container(
            height: kToolbarHeight,
            margin:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: TextField(
              controller: searchTextFieldController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  key: SearchPage.searchIconButtonKey,
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    isSearching = true;
                    setState(() {});
                    await getImageFromQuery(searchTextFieldController.text);
                    isSearching = false;
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          _getItemsGrid()
        ],
      ),
    );
  }

  Expanded _getItemsGrid() {
    return Expanded(
      child: StreamBuilder(
        stream: searchStream.stream,
        builder: (context, AsyncSnapshot<PexelsSearchResult> snapshot) {
          print("Connection State: ${snapshot.connectionState}");
          if (isSearching) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            return _getGridViewBuilder(snapshot);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return getCenteredText("Enter a Query");
          }
          return getCenteredText("An Error Occured");
        },
      ),
    );
  }

  GridView _getGridViewBuilder(AsyncSnapshot<PexelsSearchResult> snapshot) {
    return GridView.builder(
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
                  imageUrl: snapshot.data!.photos[index].src.medium,
                ),
              ),
            );
          },
          child: Image.network(
            snapshot.data!.photos[index].src.medium,
            key: ValueKey(index),
            fit: BoxFit.cover,
          ),
        );
      },
      itemCount: snapshot.data!.perPage,
    );
  }

  getCenteredText(String content) {
    return Center(
      child: Text(content),
    );
  }
}
