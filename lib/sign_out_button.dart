import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
       onPressed: () async {
                      await FirebaseAuth.instance.signOut();
        },
      child: Text('Sign Out'),
    );
  }
}