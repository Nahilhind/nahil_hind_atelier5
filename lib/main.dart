import 'package:atelier4_h_nahil_iir5g2/listeProduits.dart';
import 'package:atelier4_h_nahil_iir5g2/listeProduitsAdmin.dart';
import 'package:atelier4_h_nahil_iir5g2/login_ecran.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import'package:atelier4_h_nahil_iir5g2/firebase_options.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseUIAuth.configureProviders([
  //   EmailAuthProvider(),
  // ]);
  runApp( MaterialApp(
    home: MyApp(),
  )
      // MainApp()
      
      ); // No need for const as MainApp doesn't have const constructor
}

// Existing code...
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define your app's theme
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              User? user = snapshot.data!;
              checkUserRoleAndRedirect(user, context);
              return Scaffold(
                body: CircularProgressIndicator(),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Products'),
                ),
                body: LoginEcran(),
              );
            }
          }
        },
      ),
    );
  }
}

void checkUserRoleAndRedirect(User? user, BuildContext context) {
  if (user != null) {
    FirebaseFirestore.instance
        .collection('adminCollection')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot adminSnapshot) {
      if (adminSnapshot.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListeProduitsAdmin()),
        );
      } else {
        FirebaseFirestore.instance
            .collection('normalUsersCollection')
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot normalUserSnapshot) {
          if (normalUserSnapshot.exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ListeProduits()),
            );
          } else {
            // If the user is neither admin nor normal user, display login screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginEcran()),
            );
          }
        });
      }
    });
  } else {
    // Handle case where user is not logged in
    print('User not logged in!');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginEcran()),
    );
  }
}