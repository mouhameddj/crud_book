import 'package:flutter/material.dart';
import 'package:livre_shop/livre_model.dart';
import 'main.dart';

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
              style: TextStyle(fontSize: 16.0),
            ),
             
              Text(
              book.description,
              style: TextStyle(fontSize: 16.0),
            ),
             SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // handle button press
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}