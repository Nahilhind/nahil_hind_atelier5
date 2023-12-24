import 'package:atelier4_h_nahil_iir5g2/login_ecran.dart';
import 'package:atelier4_h_nahil_iir5g2/produit.dart';
import 'package:atelier4_h_nahil_iir5g2/produitDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ListeProduitsAdmin extends StatelessWidget {
   FirebaseFirestore db = FirebaseFirestore.instance;

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
              title: Text('Admin Interface'),
              backgroundColor: Colors.blue,
              actions: [

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
                      //  trailing: Text('${produit.prix} '),
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
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _modifierProduit(
                                  context, produit); // Edit the product
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _supprimerProduit(
                                  context, produit); // Delete the product
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
              onPressed: () async {
                final newProductDetails = await showDialog(
                  context: context,
                  builder: (context) => AddProductDialog(),
                );

                if (newProductDetails != null) {
                  // Add the new product
                }
              },
              child: Icon(Icons.add),
            ),
          );
        } else {
          return LoginEcran();
        }
      },
    );
  }

void _supprimerProduit(BuildContext context, Produit produit) async {
    try {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Supprimer le produit'),
            content: Text('Êtes-vous sûr de vouloir supprimer le produit ' +
 produit.designation +  ' ?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the alert dialog
                },
                child: Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Implement functionality for deleting the product
                  await FirebaseFirestore.instance
                      .collection('produits')
                      .doc(produit.id)
                      .delete();

                  Navigator.pop(context); // Close the alert dialog
                },
                child: Text('Supprimer'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error deleting Produit: $e');
      // Log or handle the error appropriately
    }

    
  }

  
  void _modifierProduit(BuildContext context, Produit produit) {
    // Implement functionality for updating the product
    final TextEditingController _marqueController = TextEditingController();
    final TextEditingController _designationController =
        TextEditingController();
    final TextEditingController _prixController = TextEditingController();
    final TextEditingController _quantiteController = TextEditingController();
    final TextEditingController _categorieController = TextEditingController();

    _marqueController.text = produit.marque;
    _designationController.text = produit.designation;
    _prixController.text = produit.prix.toString();
    _quantiteController.text = produit.quantite.toString();
    _categorieController.text = produit.categorie;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier la pharmacie'),
          content: Column(
            children: [
              TextField(
                controller: _marqueController,
                decoration: InputDecoration(labelText: ' Marque'),
              ),
              TextField(
                controller: _designationController,
                decoration: InputDecoration(labelText: 'Designation'),
              ),
              TextField(
                controller: _prixController,
                decoration: InputDecoration(labelText: 'Prix'),
              ),
              TextField(
                controller: _quantiteController,
                decoration: InputDecoration(labelText: 'Quantite'),
              ),
              TextField(
                controller: _categorieController,
                decoration: InputDecoration(labelText: 'Categorie'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // Add your logic here for updating the product
                produit.marque = _marqueController.text;
                produit.designation = _designationController.text;
                produit.prix = double.parse(_prixController.text);
                produit.quantite = int.parse(_quantiteController.text);
                produit.categorie = _categorieController.text;

                // Update the Firestore document using produit.id
                await FirebaseFirestore.instance
                    .collection('produits')
                    .doc(produit.id)
                    .update({
                  'marque': produit.marque,
                  'designation': produit.designation,
                  'prix': produit.prix,
                  'quantite': produit.quantite,
                  'categorie': produit.categorie,
                });

                Navigator.pop(context); // Close the dialog
              },
              child: Text('Modifier'),
            ),
          ],
        );
      },
    );
  }
}

class AjoutProduit extends StatelessWidget {
  final TextEditingController _marqueController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();

  // Ajoutez d'autres contrôleurs pour les détails du produit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _designationController,
              decoration: InputDecoration(labelText: 'Désignation'),
            ),
            TextFormField(
              controller: _marqueController,
              decoration: InputDecoration(labelText: 'Marque'),
            ),
            // Ajoutez des champs pour d'autres détails du produit
            ElevatedButton(
              onPressed: () {
                AddProductDialog(); // Appel à la fonction d'ajout de produit
                Navigator.pop(
                    context); // Revenir à la liste des produits après l'ajout
              },
              child: Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

 
}
class AddProductDialog extends StatelessWidget {
  final TextEditingController _marqueController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Product Marque'),
              controller: _marqueController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Categorie'),
              controller: _categorieController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Designation'),
              controller: _designationController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Prix'),
              controller: _prixController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Quantite'),
              controller: _quantiteController,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseFirestore.instance.collection('produits').add({
              'marque': _marqueController.text,
              'designation': _designationController.text,
              'prix': double.parse(_prixController.text),
              'quantite': int.parse(_quantiteController.text),
              'categorie': _categorieController.text,
            });

            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}