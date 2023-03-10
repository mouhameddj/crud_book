import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:livre_shop/Commande.dart';
import 'package:sqflite/sqflite.dart';

class MaPanier extends StatefulWidget {
  @override
  _MaPanierState createState() => _MaPanierState();
}

class _MaPanierState extends State<MaPanier> {
  List<Map<String, dynamic>> _donnees = [];
   double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _afficherDonnees();
  }

  Future<void> _afficherDonnees() async {
    // Ouvrir la base de données Sqflite
    final database = await openDatabase('livrebd.db');
    
    // Récupérer les données de la table
    final donnees = await database.query('panier');
     double total = 0.0;
      for (final donnee in donnees) {
      final int quantite = donnee['quantite'] as int;
      final double prix = (donnee['price']as double)!* quantite;
      total += prix;
    }
    
    // Fermer la base de données Sqflite
    await database.close();

    setState(() {
      _donnees = donnees;
      totalPrice = total;
    });
  }

  Future<void> _incrementQuantity(int id) async {
    final database = await openDatabase('livrebd.db');
    await database.rawUpdate('UPDATE panier SET quantite = quantite + 1 WHERE id = ?', [id]);
    
    await _afficherDonnees();
  }

  Future<void> _decrementQuantity(int id) async {
    final database = await openDatabase('livrebd.db');
    await database.rawUpdate('UPDATE panier SET quantite = quantite - 1 WHERE id = ?', [id]);
    await _afficherDonnees();
  }
  Future<void> _deleteItem(int id) async {
  final database = await openDatabase('livrebd.db');
  await database.rawDelete('DELETE FROM panier WHERE id = ?', [id]);
  await _afficherDonnees();
}

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Mon panier'),
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _donnees.length,
            itemBuilder: (context, index) {
              final donnee = _donnees[index];
              final int quantite = donnee['quantite'];
              final double prix = donnee['price'] * quantite;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      donnee['image'],
                      width: 120,
                      height: 150,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            donnee['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          
                          SizedBox(height: 16),
                          Row(
                            children: [
                              IconButton(
                                onPressed: quantite > 1
                                    ? () => _decrementQuantity(donnee['id'])
                                    : null,
                                icon: Icon(Icons.remove),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '$quantite',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => _incrementQuantity(donnee['id']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteItem(donnee['id']),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '$prix €',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prix total:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$totalPrice €',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
               Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Commande(totalPrice: totalPrice),
      ),
    );
            },
            child: Text(
              'Commander',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    ),
  );
}
}