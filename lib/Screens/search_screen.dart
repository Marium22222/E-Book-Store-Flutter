import 'package:ebook_store/Screens/detailed_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen(
      {Key? key, required this.searchResults, required this.func})
      : super(key: key);

  final Function() func;
  final List<Map<String, dynamic>> searchResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        leading: const Icon(Icons.search),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Your Search Results",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Times New Roman",
                fontStyle: FontStyle.italic,
                fontSize: 20,
                color: Colors.deepPurple),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> book = searchResults[index];
                return InkWell(
                  onTap: () {
                    Get.to(() => DetailedScreen(
                          image: book['image'],
                          description: book['description'],
                          author: book['author'],
                          title: book['title'],
                          price: book['price'],
                          fun: func,
                        ));
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 150,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      book['title'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Image.network(
                                      book['image'],
                                      fit: BoxFit.contain,
                                      width: 100,
                                      height: 80,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      'BY: ${book['author']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      'Rs.${book['price']}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
