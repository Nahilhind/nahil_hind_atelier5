import 'package:atelier4_h_nahil_iir5g2/favorieProducts.dart';
import 'package:atelier4_h_nahil_iir5g2/login_ecran.dart';
import 'package:atelier4_h_nahil_iir5g2/produit.dart';
import 'package:atelier4_h_nahil_iir5g2/produitDetails.dart';
import 'package:atelier4_h_nahil_iir5g2/profil.dart';
import 'package:atelier4_h_nahil_iir5g2/sign_out_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: must_be_immutable
class ListeProduits extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;

  ListeProduits({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Client Interface'),
              backgroundColor: Colors.blue,
              actions: [
                IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Récupérez l'utilisateur actuellement connecté
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null) {
              
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
                );
              }
            },
          ),
                SignOutButton(),
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: db.collection("produits").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Une erreur est survenue'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Produit> produits = snapshot.data!.docs.map((doc) {
                  return Produit.fromFirestore(doc);
                }).toList();

                return ListView.builder(
                  itemCount: produits.length,
                  itemBuilder: (context, index) {
                    final produit = produits[index];
                    return ListTile(
                      title: Text(produit.marque),
                      subtitle: Text(produit.designation),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProduitDetails(produit: produit),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FutureBuilder<bool>(
                            future: _checkIfFavorie(produit),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot.hasData) {
                                return SizedBox();
                              }
                              final isFavorie = snapshot.data!;
                              return IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: isFavorie ? Colors.yellow : null,
                                ),
                                onPressed: () {
                                  if (isFavorie) {
                                    FirebaseFirestore.instance
                                        .collection('favorie')
                                        .where('designation',
                                            isEqualTo: produit.designation)
                                        .get()
                                        .then((snapshot) {
                                      snapshot.docs.first.reference.delete();
                                    });
                                  } else {
                                    _Favorie(context, produit);
                                  }
                                },
                              );
                            },
                          ),
                      
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavorieProducts(),
                  ),
                );
              },
              child: Icon(Icons.favorite),
            ),
          );
        } else {
          return LoginEcran();
        }
      },
    );
  }

  Future<bool> _checkIfFavorie(Produit produit) async {
    final favorieSnapshot = await FirebaseFirestore.instance
        .collection('favorie')
        .where('designation', isEqualTo: produit.designation)
        .get();

    return favorieSnapshot.docs.isNotEmpty;
  }

  void _supprimerProduit(BuildContext context, Produit produit) {
    // Implement deleting a product
  }

  void _Favorie(BuildContext context, Produit produit) {
    FirebaseFirestore.instance.collection('favorie').add({
      'designation': produit.designation,
      'marque': produit.marque,
      'prix': produit.prix,
      'quantite': produit.quantite,
      'categorie': produit.categorie,
    });
  }
}
