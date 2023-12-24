import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    Future<void> _signInWithEmailAndPassword() async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
        );
        if (userCredential.user != null) {
          // Login successful, handle navigation or other actions
          print('Login successful: ${userCredential.user!.email}');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for the user.');
        } else {
          print('Error: $e');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('login'),
        backgroundColor: const Color.fromARGB(255, 33, 243, 233),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('login'),
            ),
          ],
        ),
      ),
    );
  }
}