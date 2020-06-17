import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  final gif;
  Preview(this.gif);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Hero(
        tag: gif['url'],
        child: Center(
          child: Image.network(
            gif['url'],
            height: double.parse(gif['height']),
            width: double.parse(gif['width']),
          ),
        ),
      ),
    );
  }
}
