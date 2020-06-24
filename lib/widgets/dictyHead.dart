import 'package:flutter/material.dart';

class DictyLabel extends StatelessWidget {
  final viewportHeight;
  final viewportWidth;
  final subHead;
  DictyLabel(this.viewportHeight, this.viewportWidth, this.subHead);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: viewportHeight * 0.15,
      child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              'Dicty',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: viewportHeight * 0.09,
                  fontFamily: 'Krungthep'),
            ),
          ),
          Positioned(
            top: viewportHeight * 0.115,
            left: viewportWidth / 2 - 78,
            child: Text(
              subHead,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
