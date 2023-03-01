import 'package:flutter/material.dart';
import 'livre_list.dart';
import 'Detaillivre.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
        ),
        body: ListView.builder(
          itemCount: livres.length,
          itemBuilder: (BuildContext context, int index) {
            final livre = livres[index];
            
            return ListTile(
          
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(book: livres[index]),
              ),
            );
          },
             leading: Image.network(livre.imageUrl),
              title: Text(livre.name),
              subtitle: Text(livre.description),
              trailing: Text('\$${livre.price}'),
            );
          },
        ),
      ),
    );
  }
}
