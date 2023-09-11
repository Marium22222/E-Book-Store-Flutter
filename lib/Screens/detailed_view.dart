import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_store/Screens/home_screen.dart';
import 'package:ebook_store/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailedScreen extends StatefulWidget {
  const DetailedScreen(
      {Key? key,
      required this.image,
      required this.title,
      required this.author,
      required this.price,
      required this.description,
      required this.fun})
      : super(key: key);
  final String image;
  final String title;
  final String author;
  final int price;
  final String description;
  final Function() fun;

  @override
  State<DetailedScreen> createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.fun();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int secondCollectionLength = await FirebaseFirestore.instance
            .collection('Cart')
            .get()
            .then((querySnapshot) => querySnapshot.size);
        Get.to(() => HomeScreen(length: secondCollectionLength));
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Detailed View'),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          leading: const Icon(Icons.description),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.network(
                  widget.image,
                  height: 250,
                  width: 250,
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 200,
                      child: Text(
                        "Title:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: 200,
                        child: Text(widget.title,
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 200,
                      child: Text(
                        "Author:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: 200,
                        child: Text(widget.author,
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 200,
                      child: Text(
                        "Price:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: 200,
                        child: Text('Rs.${widget.price}',
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ),
                    ),
                  ],
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const SizedBox(
                    width: 200,
                    child: Text(
                      "Description:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Flexible(
                    child: SizedBox(
                      width: 200,
                      child: Text(widget.description,
                          style: const TextStyle(
                            fontSize: 18,
                          )),
                    ),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 200,
                      child: Text(
                        'Ratings:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: 200,
                        child: Row(
                          children: [
                            const Text(
                              "5.0",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                                width: 100,
                                height: 50,
                                child: Image.network('https://t3.ftcdn.net/jp'
                                    'g/03/35/91/90/360_F_335919003_TH0ZtH'
                                    'ZZ5QGT34n1NcQXzRGvz4Pthg11.jpg')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () async {
                      sendDatatoFirebase();

                      widget.fun();
                      const snackBar = SnackBar(
                        content: Text('Item added to cart'),
                        duration: Duration(
                            seconds: 2), // Adjust the duration as needed
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo),
                    child: const Text("Add to Cart"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendDatatoFirebase() async {
    Cart cart1 = Cart(
        title: widget.title,
        author: widget.author,
        image: widget.image,
        price: widget.price,
        description: widget.description);

    var id1 = FirebaseFirestore.instance.collection('Cart').doc();
    await id1.set(cart1.toJson());
  }
}
