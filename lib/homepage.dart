// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mayssa_app/addproduct.dart';
import 'package:mayssa_app/controllerinterface.dart';
import 'package:mayssa_app/loginpages/login.dart';
import 'package:mayssa_app/shared/productcard.dart';
import 'package:mayssa_app/update_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map userDate = {};
  bool isLoading = true;
  getData() async {
    // Get data from DB
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userDate = snapshot.data()!;
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: userDate['role'] == 'user'
          ? AppBar(
              backgroundColor: Colors.white,
              actions: [
                GestureDetector(
                  onTap: ()async{
                      await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                              (route) => false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right:20.0),
                    child: Icon(
                      Icons.logout,
                      color: Colors.indigo,
                    ),
                  ),
                )
              ],
            )
          : AppBar(
              leading: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ControllerInterface()));
                  },
                  child: Icon(Icons.app_registration)),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddProduct()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: const Icon(
                      Icons.add_circle_outline_outlined,
                      color: Colors.indigo,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('product').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
              
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }
              
                      return GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15),
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return            ProductCard(
                 imageurl: data['imgLink'],
                        productName: data['name'],
                        quantity: data['quantity'],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateProduct()));
                        },
                      );
                        }).toList(),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    ));
  }
}
