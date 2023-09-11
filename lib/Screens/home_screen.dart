import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_store/Screens/detailed_view.dart';
import 'package:ebook_store/Screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.length}) : super(key: key);
  final int length;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

TextEditingController input1 = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  double totalBill = 0.0;
  int documentCount = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotalPrice();
    getDocumentCount();
  }

  Future<void> getDocumentCount() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Cart').get();
      int count = querySnapshot.size;
      setState(() {
        documentCount = count;
      });
    } catch (e) {
      print('Error fetching document count: $e');
    }
  }

  Future<void> _calculateTotalPrice() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Cart').get();

      double sum = 0.0;
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        final data = document.data() as Map<String, dynamic>;

        if (data.containsKey('price')) {
          sum += data['price'];
        }
      }
      totalBill = sum;
      setState(() {});
    } catch (e) {
      print('Error calculating total price: $e');
    }
  }

  String toTitleCase(String text) {
    if (text.isEmpty) {
      return text;
    }

    List<String> words = text.split(' ');
    List<String> titleCaseWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        String titleCaseWord =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
        titleCaseWords.add(titleCaseWord);
      }
    }

    return titleCaseWords.join(' ');
  }

  Future<void> searchBooks() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('Book') // Replace 'books' with your collection name
          .where('title', isGreaterThanOrEqualTo: toTitleCase(input1.text))
          .where('title',
              isLessThanOrEqualTo: '${toTitleCase(input1.text)}\uf8ff')
          .get();
      if (querySnapshot.docs.isEmpty) {
        // If no results are found by title, search by author
        querySnapshot = await firestore
            .collection('Book')
            .where('author', isGreaterThanOrEqualTo: toTitleCase(input1.text))
            .where('author',
                isLessThanOrEqualTo: '${toTitleCase(input1.text)}\uf8ff')
            .get();
      }
      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> searchResults = [];
        for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in querySnapshot.docs) {
          Map<String, dynamic> data = document.data();
          Get.to(() => SearchScreen(
              searchResults: searchResults, func: _calculateTotalPrice));
          searchResults.add(data);
        }
      } else {
        print('No matching documents found.');
      }
    } catch (e) {
      print('Error searching for documents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-book Store"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        leading: const Icon(Icons.home),
      ),
      body: StreamBuilder<
              QuerySnapshot<Map<String, dynamic>>>
          (
          stream: FirebaseFirestore.instance.collection("Book").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null || snapshot.hasError) {
              return const Center(child: Text("data not available"));
            }
            return Column(
              children: [
                ListTile(
                  leading: GestureDetector(
                      onTap: () {
                        searchBooks();
                      },
                      child: const Icon(
                        Icons.search,
                        size: 50,
                        color: Colors.indigo,
                      )),
                  title: TextField(
                    controller: input1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search a book by author or title',
                    ),
                  ),
                  trailing: InkWell(
                      onTap: () {
                        _calculateTotalPrice();
                        getDocumentCount();

                        Get.to(() => CartScreen(
                              bill: totalBill,
                              func1: _calculateTotalPrice,
                            ));
                        //bill pass from here.
                      },
                      child: Column(
                        children: [
                          Container(
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                child: Text(
                                  '${widget.length}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          const Icon(
                            Icons.shopping_cart,
                            size: 30,
                            color: Colors.indigo,
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Find Your Desired Books",
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc1 = snapshot.data!.docs[index];
                        Map<String, dynamic> data =
                            doc1.data() as Map<String, dynamic>;

                        return InkWell(
                          onTap: () {
                            Get.to(() => DetailedScreen(
                                image: data['image'],
                                description: data['description'],
                                author: data['author'],
                                title: data['title'],
                                price: data['price'],
                                fun: _calculateTotalPrice));
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
                                              data['title'],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Image.network(
                                              data['image'],
                                              fit: BoxFit.contain,
                                              width: 100,
                                              height: 80,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            width: 130,
                                            child: Text(
                                              'BY: ${data['author']}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              'Rs.${data['price']}',
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
                      }),
                ),
              ],
            );
          }),
    );
  }
}
