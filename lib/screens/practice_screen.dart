import 'dart:async';

import 'dart:math';
import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/helpers/practice.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class PracticeScreen extends StatefulWidget {
  final MainModel model;
  PracticeScreen(this.model);
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with TickerProviderStateMixin {
  var viewportHeight;
  var viewportWidth;
  var practiceWord = '';
  String practiceTrans = '';
  bool hintNeeded = false;
  bool correctAns = false;
  bool showTrans = false;
  bool ansRevealed = false;
  bool showDef = false;
  bool showSen = false;
  AnimationController _animationController;
  Animation<double> _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  List<String> options = [];
  var wordObj;
  List defs = [];
  List sentences = [];

  @override
  void initState() {
    super.initState();
    showTrans = false;
    setOptions();

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

  void loadDef_Sen() {
    widget.model.searchWordDict(practiceWord).then((list) {
      wordObj = list[0];
      if (wordObj is String) {
        print('It is a string man');
      } else {
        defs = wordObj['shortdef'];
        wordObj['def'][0]['sseq'][0][0][1]['dt'][1][1].forEach((obj) {
          sentences.add(widget.model.parseSentence(obj['t']));
        });
      }
    });
  }

  void setOptions() {
    List list = [];
    int option1 = new Random().nextInt(practiceOptions.length);
    int option2 = new Random().nextInt(practiceOptions.length);
    int option3 = new Random().nextInt(practiceOptions.length);
    int option4 = new Random().nextInt(practiceOptions.length);
    int correctoption = new Random().nextInt(4);
    list.add(practiceOptions[option1]);
    list.add(practiceOptions[option2]);
    list.add(practiceOptions[option3]);
    list.add(practiceOptions[option4]);
    practiceWord = list[correctoption];
    widget.model.translateIBM(list).then((newlist) {
      newlist.forEach((element) {
        options.add(element['translation']);
      });
      practiceTrans = newlist[correctoption]['translation'];
    });
    loadDef_Sen();
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
                    _button('Definitions'),
                    _button('Sentences'),
                  ],
                ),
              ),
              Container(
                height: viewportHeight * 0.6,
                child: TinderSwapCard(
                  orientation: AmassOrientation.TOP,
                  totalNum: 50,
                  stackNum: 2,
                  maxHeight: viewportHeight * 0.65,
                  maxWidth: viewportWidth * 0.85,
                  minHeight: viewportHeight * 0.6,
                  minWidth: viewportWidth * 0.8,
                  swipeUpdateCallback: (details, align) {},
                  swipeCompleteCallback: (orientation, index) {
                    setOptions();
                  },
                  cardBuilder: (context, index) {
                    return Card(child: _wordBox());
                  },
                ),
              ),
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
            onPressed: () {
              setState(() {
                if (title == 'Sentences') {
                  showSen = !showSen;
                } else {
                  showDef = !showDef;
                }
              });
            }),
      ),
    );
  }

  Widget _optionButton(String word) {
    var changeColor = false;
    if (correctAns && word == practiceTrans) {
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
              if (word == practiceTrans) {
                setState(() {
                  correctAns = true;
                  ansRevealed = true;
                  showTrans = !showTrans;

                  if (_animationStatus == AnimationStatus.dismissed) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                });
                Timer(Duration(seconds: 2), () {
                  setState(() {
                    hintNeeded = false;
                    correctAns = false;
                    ansRevealed = true;
                    showTrans = !showTrans;

                    if (_animationStatus == AnimationStatus.dismissed) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
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
    if (showTrans && ansRevealed) {
      currWord = practiceTrans;
    } else {
      currWord = practiceWord;
    }
    if (!showDef && !showSen) {
      return Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(_animation.value >= 0.5
              ? 3.14 * _animation.value + 3.14
              : 3.14 * _animation.value),
        child: GestureDetector(
          onTap: () {
            if (ansRevealed) {
              if (_animationStatus == AnimationStatus.dismissed) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
              setState(() {
                showTrans = !showTrans;
              });
            }
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
                                    _optionButton(options[0]),
                                    _optionButton(options[1]),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _optionButton(options[2]),
                                    _optionButton(options[3]),
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
    } else if (showDef && !showSen) {
    } else {}
  }
}
