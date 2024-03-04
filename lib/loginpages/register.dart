import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mayssa_app/homepage.dart';
import 'package:mayssa_app/shared/customtextfield.dart';
import 'package:mayssa_app/shared/registerbutton.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isFocused = false;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  register() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "fullname": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "role": "user",
        "uid": FirebaseAuth.instance.currentUser!.uid,
      });
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    } on FirebaseAuthException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.indigo,
                  ),
                ),
              ),
              const SizedBox(height: 50,),
              CustomTfield(
                isPassword: false,
                text: 'Full Name',
                icon: Icons.person_2_outlined,
                myController: nameController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTfield(
                isPassword: false,
                text: 'Email',
                icon: Icons.email_outlined,
                myController: emailController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTfield(
                isPassword: true,
                text: 'Password',
                icon: Icons.visibility_off_outlined,
                myController: passwordController,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await register();
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.indigo),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        child: isLoading
                            ? LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 50,
                              )
                            : const Padding(
                              padding:  EdgeInsets.all(10.0),
                              child:  Text(
                                  'Register',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
                      const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.7,
                      )),
                      Text(
                        "     OR     ",
                        style: TextStyle(color: Colors.black45),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.7,
                      )),
                    ],
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
             
                const RegisterButton(
                    text: 'Google', link: 'assets/icons/google.svg'),
                const SizedBox(
                  height: 20,
                ),
                const RegisterButton(
                    text: 'Facebook', link: 'assets/icons/facebook.svg'),
                const SizedBox(
                  height: 20,
                ),
                const RegisterButton(
                    text: 'Apple', link: 'assets/icons/apple.svg'),
            ],
          ),
        ),
      ),
    );
  }
}
