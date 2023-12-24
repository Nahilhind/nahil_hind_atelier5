
import 'package:atelier4_h_nahil_iir5g2/loginForm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginEcran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Placeholder for loading state
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            User? user = snapshot.data!;
            return Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Email: ${user.email}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: Text('Se déconnecter'),
                  ),
                ],
              ),
            );
          } else {
            return LoginForm(); // Display the login form if no user is logged in
          }
        }
      },
    );
  }
}
