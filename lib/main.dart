import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_store/Screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  int secondCollectionLength = await FirebaseFirestore.instance
      .collection('Cart')
      .get()
      .then((querySnapshot) => querySnapshot.size);

  runApp(GetMaterialApp(
    home: HomeScreen(
      length: secondCollectionLength,
    ),
    debugShowCheckedModeBanner: false,
  ));
}


