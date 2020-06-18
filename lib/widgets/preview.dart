import 'package:dictyapp/helpers/dimensions.dart';
import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  final gif;
  Preview(this.gif);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getDeviceHeight(context),
      width: getDeviceWidth(context),
      color: Colors.black.withOpacity(0.7),
      child: Hero(
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
