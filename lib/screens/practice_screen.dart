import 'dart:async';

import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';

class PracticeScreen extends StatefulWidget {
  final MainModel model;
  PracticeScreen(this.model);
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with SingleTickerProviderStateMixin {
  var viewportHeight;
  var viewportWidth;
  var practiceWord = 'Psychology';
  String practiceTrans = '';
  var correctWord = 'four';
  bool hintNeeded = false;
  bool correctAns = false;
  bool showTrans = false;
  AnimationController _animationController;
  Animation<double> _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    showTrans = false;
    widget.model.translateIBM([practiceWord]).then((list) {
      practiceTrans = list[0]['translation'];
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(end: 1, begin: 0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              navbarButton(),
              DictyLabel(viewportHeight, viewportWidth, 'FlashCards.'),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _button('Movie Texts'),
                    _button('Sentences'),
                  ],
                ),
              ),
              _wordBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: viewportWidth * 0.4,
        child: RaisedButton(
            color: Color(0xfff7c49e),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: viewportHeight * 0.02,
                    fontFamily: 'Krungthep'),
              ),
            ),
            onPressed: () {}),
      ),
    );
  }

  Widget _optionButton(String word) {
    var changeColor = false;
    if (correctAns && word == correctWord) {
      changeColor = true;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: viewportWidth * 0.35,
        child: RaisedButton(
            color: changeColor ? Colors.green : Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                word,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: viewportHeight * 0.02,
                    fontFamily: 'Krungthep'),
              ),
            ),
            onPressed: () {
              if (word == correctWord) {
                setState(() {
                  correctAns = true;
                });
                Timer(Duration(seconds: 2), () {
                  setState(() {
                    practiceWord = 'Native Word';
                    hintNeeded = false;
                    correctAns = false;
                  });
                });
              }
            }),
      ),
    );
  }

  Widget navbarButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: viewportHeight * 0.05,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget _wordBox() {
    String currWord;
    if (showTrans) {
      currWord = practiceTrans;
    } else {
      currWord = practiceWord;
    }
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateY(_animation.value >= 0.5
            ? 3.14 * _animation.value + 3.14
            : 3.14 * _animation.value),
      child: GestureDetector(
        onTap: () {
          if (_animationStatus == AnimationStatus.dismissed) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
          setState(() {
            showTrans = !showTrans;
          });
        },
        child: Container(
          height: viewportHeight * 0.6,
          width: viewportWidth * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.white,
              )
            ],
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      MyFlutterApp.question,
                      size: viewportHeight * 0.04,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        hintNeeded = true;
                      });
                    },
                  ),
                ],
              ),
              Container(
                height: viewportHeight * 0.41,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      currWord,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Krungthep',
                          fontSize: viewportHeight * 0.045),
                    ),
                    hintNeeded
                        ? Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _optionButton('one'),
                                  _optionButton('two'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _optionButton('three'),
                                  _optionButton('four'),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Center(
                child: IconButton(
                  icon: Icon(
                    MyFlutterApp.volume,
                    size: viewportHeight * 0.052,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    widget.model.initializeTts();
                    widget.model.ttsspeak(practiceWord).then((_) {
                      // model.flutterTts.stop();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
