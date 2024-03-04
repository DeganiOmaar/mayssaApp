import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mayssa_app/homepage.dart';
import 'package:mayssa_app/shared/customtextfield.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' show basename;

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {

  TextEditingController productNameController = TextEditingController();
  TextEditingController productquantityController = TextEditingController();

  bool isVisable = true;
  File? imgPath;
  String? imgName;
  bool isLoading = false;
  uploadImage2Screen() async {
    final XFile? pickedImg =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (pickedImg != null) {
        imgPath = File(pickedImg.path);
        setState(() {
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }

  UpdateProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
// Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref("$imgName");
      await storageRef.putFile(imgPath!);
      String urll = await storageRef.getDownloadURL();

      CollectionReference course =
          FirebaseFirestore.instance.collection('product');
      String newId = const Uuid().v1();
      course.doc(newId).set({
        "imgLink": urll,
        'name': productNameController.text,
        'quantity': productquantityController.text,
      });
    } catch (err) {
      if (!mounted) return;
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  imgPath == null
                      ? const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 225, 225, 225),
                          radius: 71,
                          backgroundImage: AssetImage("assets/images/new.jpg"),
                        )
                      : ClipOval(
                          child: Image.file(
                            imgPath!,
                            width: 145,
                            height: 145,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Positioned(
                    left: 95,
                    bottom: -10,
                    child: IconButton(
                      onPressed: () {
                        uploadImage2Screen();
                      },
                      icon: const Icon(Icons.add_a_photo),
                      color: const Color.fromARGB(255, 94, 115, 128),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTfield(
                isPassword: false,
                text: "Prodct Name",
                icon: Icons.edit,
                myController: productNameController),
            const SizedBox(
              height: 20,
            ),
            CustomTfield(
                isPassword: false,
                text: "Prodct quantity",
                icon: Icons.production_quantity_limits_rounded,
                myController: productquantityController),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () async {
                    await UpdateProduct();
                    if (!mounted) return;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)))),
                  child: 
                  isLoading ?
                  LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white,
                            size: 50,
                          ):
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 13.0),
                    child: Text(
                      "Add Product",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
