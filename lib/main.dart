import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mayssa_app/firebase_options.dart';
import 'package:mayssa_app/homepage.dart';
import 'package:mayssa_app/loginpages/login.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: FirebaseAuth.instance.currentUser == null
          ? const Login():
          const HomePage()
      
       
    );
  }
}