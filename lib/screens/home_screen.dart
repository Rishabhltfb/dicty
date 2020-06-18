import 'dart:async';

import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/screens/word_screen.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:speech_recognition/speech_recognition.dart';

class HomeScreen extends StatefulWidget {
  final MainModel model;
  HomeScreen(this.model);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var viewportHeight;
  var viewportWidth;
  var searchWord = '';
  bool hideButtons = false;
  bool showMyWords = false;
  bool typing = false;
  bool showResults = false;
  bool _isLoading = false;
  List<dynamic> dict_words = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int currTransindex;
  List<Map> mywordObjs = [];
  List<String> mywords = [];
  List<String> mywordsTrans = [];
  // speech
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    activateSpeechRecognizer(); // speech
    currTransindex = -1;
    widget.model.fetchMyWords().then((_) {
      mywordObjs = widget.model.myWords;
      mywordObjs.forEach((wordObj) {
        mywords.add(wordObj['meta']['id']);
      });
      if (mywords.isNotEmpty) {
        widget.model.translateIBM(mywords).then((list) {
          list.forEach((element) {
            mywordsTrans.add(element['translation']);
          });
        });
      }
    });

    super.initState();
  }

  void activateSpeechRecognizer() {
    widget.model.requestPermission();

    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  void start() => _speech
      .listen(locale: 'en_US')
      .then((result) => print('Started listening => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
        setState(() => _isListening = result);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) =>
      setState(() => print("current locale: $locale"));

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) {
    setState(() {
      searchWord = text;
    });
  }

  void onRecognitionComplete() {
    widget.model.searchWordDict(searchWord).then((list) {
      if (list != null && typing) {
        setState(() {
          dict_words = list;
          typing = true;
          hideButtons = true;
          showResults = true;
        });
      }
    });
    _textEditingController.value = TextEditingValue(
      text: searchWord,
      selection: TextSelection.fromPosition(
        TextPosition(offset: searchWord.length),
      ),
    );

    setState(() {
      _isListening = false;
    });
  }

  Widget searchWidget() {
    return Container(
      // color: Colors.yellow,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white24,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _textEditingController,
          onChanged: (String value) {
            if (value.isNotEmpty) {
              widget.model.searchWordDict(value).then((list) {
                if (list != null && typing) {
                  setState(() {
                    dict_words = list;
                    typing = true;
                    hideButtons = true;
                    showResults = true;
                  });
                }
              });
            } else {
              FocusScope.of(context).requestFocus(FocusNode());
              searchWord = '';
              _textEditingController.value = TextEditingValue(
                text: '',
                selection: TextSelection.fromPosition(
                  TextPosition(offset: searchWord.length),
                ),
              );
              setState(() {
                dict_words = [];
                hideButtons = false;
                typing = false;
                showResults = false;
              });
            }
            searchWord = value;
          },
          onSaved: (String value) {
            searchWord = value;
          },
          onTap: () {
            setState(() {
              hideButtons = true;
              typing = true;
              showMyWords = false;
            });
          },
          style: TextStyle(
            fontSize: getViewportHeight(context) * 0.02,
            color: Theme.of(context).accentColor,
            fontFamily: 'Krungthep',
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            alignLabelWithHint: false,
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).accentColor,
              size: getViewportHeight(context) * 0.025,
            ),
            labelText: 'Search Word',
            labelStyle: TextStyle(
              fontFamily: "Krungthep",
              fontSize: viewportHeight * 0.02,
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.w200,
            ),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide:
                  BorderSide(color: Theme.of(context).accentColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.white70, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget myWordsList(context, MainModel model) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      width: viewportWidth * 0.8,
      height: viewportHeight * 0.5,
      child: mywords.length > 0
          ? ListView.separated(
              itemCount: mywords.length,
              padding: EdgeInsets.symmetric(horizontal: 5),
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var word = currTransindex == index
                    ? mywordsTrans[index]
                    : mywords[index];
                return ListTile(
                  title: Text(
                    word,
                    style: TextStyle(
                        fontFamily: 'Krungthep',
                        color: Theme.of(context).primaryColor),
                  ),
                  onTap: () {
                    setState(() {
                      showMyWords = false;
                      hideButtons = false;
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            WordScreen(mywordObjs[index], model),
                      ),
                    );
                  },
                  trailing: Container(
                    width: viewportWidth * 0.27,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.translate,
                            size: viewportHeight * 0.02,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              if (currTransindex != index) {
                                currTransindex = index;
                              } else {
                                currTransindex = -1;
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            MyFlutterApp.volume,
                            size: viewportHeight * 0.02,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            widget.model.initializeTts();
                            model.ttsspeak(word).then((_) {
                              // model.flutterTts.stop();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ); // Add Comment tile
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Theme.of(context).primaryColor,
                );
              },
            )
          : Center(
              child: Text(
                'No Words',
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Krungthep',
                    fontSize: viewportHeight * 0.05),
              ),
            ),
    );
  }

  Widget _button(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: title != 'Speak Instead'
            ? viewportWidth * 0.6
            : viewportWidth * 0.36,
        child: RaisedButton(
            color: _isListening ? Colors.blue : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                    color: _isListening
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontSize: title != 'Speak Instead'
                        ? viewportHeight * 0.03
                        : viewportHeight * 0.015,
                    fontFamily: 'Krungthep'),
              ),
            ),
            onPressed: () {
              if (title == 'My Words') {
                setState(() {
                  widget.model.fetchMyWords().then((value) {
                    setState(() {
                      mywordObjs = widget.model.myWords;
                      mywords = [];
                      mywordsTrans = [];
                      mywordObjs.forEach((wordObj) {
                        mywords.add(wordObj['meta']['id']);
                      });
                      if (mywords.isNotEmpty) {
                        widget.model.translateIBM(mywords).then((list) {
                          list.forEach((element) {
                            mywordsTrans.add(element['translation']);
                          });
                        });
                      }
                    });
                  });
                  hideButtons = true;
                  showMyWords = true;
                });
              } else if (title == 'Practice') {
                Navigator.of(context).pushNamed('/practice');
              } else if (title == 'Speak Instead' &&
                  _speechRecognitionAvailable &&
                  !_isListening) {
                start();
              }
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);

    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (searchWord == '' && !showMyWords) {
                    setState(() {
                      typing = false;
                      hideButtons = false;
                      showResults = false;
                    });
                  }
                },
                child: ScopedModelDescendant<MainModel>(
                  builder: (context, child, model) {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          navbarButton(),
                          DictyLabel(viewportHeight, viewportWidth, ''),
                          SizedBox(
                            height: viewportHeight * 0.12,
                          ),
                          Container(
                            height: viewportHeight * 0.05,
                            width: viewportWidth * 0.6,
                            child: searchWidget(),
                          ),
                          typing ? _button('Speak Instead') : Container(),
                          showResults ? searchedWords() : Container(),
                          SizedBox(
                            height: viewportHeight * 0.05,
                          ),
                          showMyWords
                              ? myWordsList(context, model)
                              : Container(),
                          hideButtons ? Container() : _button('My Words'),
                          hideButtons ? Container() : _button('Practice'),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget searchedWords() {
    var list = [];
    dict_words.forEach((wordobj) {
      if (wordobj is String) {
        list.add(wordobj);
      } else {
        list.add(wordobj['meta']['id']);
      }
    });
    return Container(
      height: viewportHeight * 0.4,
      width: viewportWidth * 0.8,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              var wordobj;
              if (dict_words[index] is String) {
                widget.model.searchWordDict(dict_words[index]).then((list) {
                  wordobj = list[0];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WordScreen(wordobj, widget.model),
                    ),
                  );
                });
              } else {
                wordobj = dict_words[index];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WordScreen(wordobj, widget.model),
                  ),
                );
              }

              searchWord = '';
              _textEditingController.value = TextEditingValue(
                text: '',
                selection: TextSelection.fromPosition(
                  TextPosition(offset: searchWord.length),
                ),
              );
              Timer(Duration(seconds: 2), () {
                setState(() {
                  hideButtons = false;
                  typing = false;
                  showResults = false;
                });
              });
            },
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                list[index],
                style: TextStyle(
                    fontFamily: 'Krungthep', fontSize: viewportHeight * 0.03),
              ),
            )),
          );
        },
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
              showMyWords ? Icons.arrow_back : Icons.settings,
              size: viewportHeight * 0.05,
            ),
            onPressed: () {
              if (showMyWords) {
                setState(() {
                  showMyWords = false;
                  hideButtons = false;
                });
              } else {
                Navigator.of(context).pushNamed('/settings');
              }
            },
          )
        ],
      ),
    );
  }
}
