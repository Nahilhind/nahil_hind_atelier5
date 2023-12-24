import 'package:atelier4_h_nahil_iir5g2/produit.dart';
import 'package:flutter/material.dart';

class ProduitDetails extends StatelessWidget {
  
  final Produit produit;
  ProduitDetails({required this.produit});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProduitDetails'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom: ${produit.designation}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          
            SizedBox(height: 8),
            Text('Categorie: ${produit.categorie}'),
            SizedBox(height: 8),
            Text('Marque: ${produit.marque}'), 
            SizedBox(height: 8),
            Text('Prix: ${produit.prix}'),   
            SizedBox(height: 8),
            Text('Quantite: ${produit.quantite}'),

          ],
        ),
      ),
    );
  }
}