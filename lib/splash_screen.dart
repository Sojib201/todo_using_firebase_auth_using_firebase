import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_firebase/home_screen.dart';
import 'package:to_do_with_firebase/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      if (_auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) =>  HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) =>  LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      // body: Center(
      //   child: Text(
      //     "ToDo App",
      //     style: TextStyle(
      //       fontSize: 32,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.white,
      //       letterSpacing: 1.5,
      //     ),
      //   ),
      // ),
    );
  }
}
