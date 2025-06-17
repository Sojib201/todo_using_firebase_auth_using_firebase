import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_with_firebase/auth_service.dart';
import 'package:to_do_with_firebase/login_screen.dart';

import 'home_screen.dart';

class RegisterScreen extends StatelessWidget {
  final AuthService auth=AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(
                onPressed: () async {
                  User? user=await auth.registerWithEmailPassword(emailController.text.trim(),passwordController.text.trim());
                  if(user!=null){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                  }
                },
                child: Text('Register')),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
              },
              child: Text("Do you have already account? Login"),
            )
          ],
        ),
      ),
    );
  }
}
