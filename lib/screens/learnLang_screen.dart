import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';

class LearnLangScreen extends StatefulWidget {
  @override
  _LearnLangScreenState createState() => _LearnLangScreenState();
}

class _LearnLangScreenState extends State<LearnLangScreen> {
  var viewportHeight;
  var viewportWidth;

  Widget _learnlangButton() {
    return FlatButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      onPressed: () {},
      child: Text(
        'English',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _continueButton() {
    return RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          'Continue',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: viewportHeight * 0.025,
              fontFamily: 'Krungthep'),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/home');
        });
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getDeviceWidth(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  width: viewportWidth,
                  child: DictyLabel(
                      viewportHeight, viewportWidth, 'Read, Learn, Repeat.'),
                ),
              ),
              SizedBox(height: viewportHeight * 0.2),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'You\'re Learning',
                    style: TextStyle(
                        fontSize: viewportHeight * 0.028,
                        fontFamily: 'Krungthep'),
                  ),
                ),
              ),
              Container(
                width: viewportWidth * 0.5,
                child: _learnlangButton(),
              ),
              SizedBox(height: viewportHeight * 0.35),
              Container(
                width: viewportWidth * 0.5,
                child: _continueButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
