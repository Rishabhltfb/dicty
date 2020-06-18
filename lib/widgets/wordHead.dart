import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:flutter/material.dart';

class WordHead extends StatelessWidget {
  final viewportHeight;
  final viewportWidth;
  final word;
  final MainModel model;
  WordHead(this.viewportHeight, this.viewportWidth, this.word, this.model);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        model.initializeTts();
        model.ttsspeak(word);
      },
      child: Center(
        child: Text(
          word,
          style: TextStyle(
              color: Colors.white,
              fontSize: viewportHeight * 0.09,
              fontFamily: 'Krungthep'),
        ),
      ),
    );
  }
}
