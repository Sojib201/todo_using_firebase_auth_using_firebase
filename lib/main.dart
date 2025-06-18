import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_firebase/home_screen.dart';
import 'package:to_do_with_firebase/login_screen.dart';
import 'package:to_do_with_firebase/registration_screen.dart';
import 'package:to_do_with_firebase/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final FirebaseAuth auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: auth.currentUser!=null?HomeScreen():LoginScreen(),
      home: SplashScreen(),
    );
  }
}

