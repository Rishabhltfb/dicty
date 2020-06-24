import 'dart:async';

import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/screens/auth_screen.dart';
import 'package:dictyapp/screens/home_screen.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final MainModel model;
  SplashScreen(this.model);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var viewportHeight;
  var viewportWidth;
  bool hasToken = false;
  bool haveNative = false;

  @override
  void initState() {
    super.initState();

    widget.model.autoAuthenticate().then((value) {
      hasToken = value;
    });
    widget.model.haveNative().then((value) {
      haveNative = value;
    });
    Timer(Duration(seconds: 4), () {
      if (hasToken) {
        print('Token authenticated');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(widget.model),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AuthScreen(widget.model),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    return Scaffold(
      body: Container(
        child: Center(
          child:
              DictyLabel(viewportHeight, viewportWidth, 'Read, Learn, Repeat.'),
        ),
      ),
    );
  }
}
