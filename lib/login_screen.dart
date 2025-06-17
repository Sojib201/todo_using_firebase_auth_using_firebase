import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_firebase/home_screen.dart';
import 'package:to_do_with_firebase/registration_screen.dart';

import 'auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService auth=AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(
                onPressed: () async {
                  User? user=await auth.signInWithEmailPassword(emailController.text.trim(),passwordController.text.trim());
                  if(user!=null){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                  }
                },
                child: Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
              },
              child: Text("Don't have an account? Register"),
            )
          ],
        ),
      ),
    );
  }
}
