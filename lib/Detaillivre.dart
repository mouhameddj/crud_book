import 'package:flutter/material.dart';
import 'package:livre_shop/livre_model.dart';
import 'package:livre_shop/mapanier.dart';
import 'main.dart';
 import 'package:sqflite/sqflite.dart';

class DetailScreen extends StatelessWidget {
  
  const DetailScreen({Key? key, required this.book}) : super(key: key);

  final Livre book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              book.imageUrl,
              width: 400,
              height: 300,
            ),
            SizedBox(height: 16.0),
            Text(
              '\$${book.price}',
               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
             
              Text(
              book.description,
              style: TextStyle(fontSize: 16.0),
            ),
             SizedBox(height: 16.0),
          

ElevatedButton(
  onPressed: () async {
    // Ouvrir la base de données Sqflite
    final database = await openDatabase('livrebd.db');
    await database.execute('''
  CREATE TABLE IF NOT EXISTS panier (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    image TEXT,
    description TEXT,
    quantite INTEGER CHECK (quantite > 0),
    price REAL
  )
''');

    // Ajouter des données
    await database.insert(
      'panier',
      {
         'name': book.name,
         'image':book.imageUrl,
         'description': book.description,
         'quantite':book.Quantity,
         'price' : book.price
      },
    );

    // Fermer la base de données Sqflite
    await database.close();
      Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MaPanier()),
          );
  },
 

              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}