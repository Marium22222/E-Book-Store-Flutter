import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_store/Screens/home_screen.dart';
import 'package:ebook_store/controllers/book_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key, required this.bill, required this.func1})
      : super(key: key);
  final double bill;
  final Function() func1;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

BookController control = Get.put(BookController());

class _CartScreenState extends State<CartScreen> {
  double bill1 = 0;
  double totalBill = 0.0;

  @override
  void initState() {
    super.initState();
    bill1 = widget.bill;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        int secondCollectionLength = await FirebaseFirestore.instance
            .collection('Cart')
            .get()
            .then((querySnapshot) => querySnapshot.size);
        Get.to(HomeScreen(
          length: secondCollectionLength,
        ));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: InkWell(
                onTap: () async {
                  int secondCollectionLength = await FirebaseFirestore.instance
                      .collection('Cart')
                      .get()
                      .then((querySnapshot) => querySnapshot.size);
                  Get.to(HomeScreen(
                    length: secondCollectionLength,
                  ));
                },
                child: const Icon(Icons.shopping_cart)),
            title: const Text("Your Cart"),
            centerTitle: true,
            backgroundColor: Colors.indigo,
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Showing Your Cart Items",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Times New Roman",
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Colors.deepPurple),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: StreamBuilder<
                        QuerySnapshot<
                            Map<String, dynamic>>>
                    (
                    stream: FirebaseFirestore.instance
                        .collection("Cart")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data == null || snapshot.hasError) {
                        return const Center(child: Text("data not available"));
                      }

                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc1 = snapshot.data!.docs[index];
                            String docID = doc1.id;
                            final documentReference = FirebaseFirestore.instance
                                .collection("Cart")
                                .doc(docID);
                            Map<String, dynamic> data =
                                doc1.data() as Map<String, dynamic>;

                            return Column(
                              children: [
                                ListTile(
                                  leading: Image.network(
                                    data['image'],
                                    width: 100,
                                    height: 100,
                                  ),
                                  title: Column(
                                    children: [
                                      const Text(
                                        "Title:",
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(data['title']),
                                      const Text(
                                        "Author:",
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(data['author']),
                                      const Text(
                                        "Description:",
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(data['description']),
                                      InkWell(
                                          onTap: () async {
                                            const snackBar = SnackBar(
                                              content: Text(
                                                  'Item removed from cart'),
                                              duration: Duration(
                                                  seconds:
                                                      2),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            await documentReference.delete();
                                            try {

                                              QuerySnapshot querySnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Cart')
                                                      .get();
                                              double sum = 0.0;
                                              for (QueryDocumentSnapshot document
                                                  in querySnapshot.docs) {
                                                final data = document.data()
                                                    as Map<String, dynamic>;

                                                if (data.containsKey('price')) {
                                                  sum += data['price'];
                                                }
                                              }
                                              setState(() {
                                                totalBill = sum;
                                                bill1 = sum;
                                              });
                                            } catch (e) {
                                              print(
                                                  'Error calculating total price: $e');
                                            }
                                          },
                                          child: const Text(
                                            "Remove",
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontStyle: FontStyle.italic,
                                                decoration:
                                                    TextDecoration.underline),
                                          )),
                                      const SizedBox(
                                        width: 300,
                                        child: Center(
                                          child: Divider(
                                            thickness: 2,
                                            height: 80,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  trailing: Column(
                                    children: [
                                      const Text(
                                        "Price",
                                        style: TextStyle(
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text('Rs.${data['price']}'),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                    }),
              ),
              Container(
                height: 50,
                width: 250,
                color: Colors.indigo[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "SUBTOTAL: ",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Rs.${bill1}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
