import 'package:flutter/material.dart';

class WordHead extends StatelessWidget {
  final viewportHeight;
  final viewportWidth;
  final word;
  WordHead(this.viewportHeight, this.viewportWidth, this.word);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        word,
        style: TextStyle(
            color: Colors.white,
            fontSize: viewportHeight * 0.09,
            fontFamily: 'Krungthep'),
      ),
    );
  }
}
