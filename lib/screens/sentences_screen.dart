import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/widgets/wordHead.dart';
import 'package:flutter/material.dart';

class SentencesScreen extends StatefulWidget {
  final wordobj;
  final MainModel model;
  SentencesScreen(this.wordobj, this.model);
  @override
  _SentencesScreenState createState() => _SentencesScreenState();
}

class _SentencesScreenState extends State<SentencesScreen> {
  var viewportHeight;
  var viewportWidth;
  int currDefTransIndex;
  int currSenTransIndex;
  bool showDefinitions = false;
  bool showAllDefinitions = false;
  bool showDefTrans = false;
  bool showSenTrans = false;
  List definitionsList = [];
  List defTransList = [];

  List sentences = [];
  List sentenceTransList = [];

  @override
  void initState() {
    super.initState();
    currDefTransIndex = -1;
    currSenTransIndex = -1;

    definitionsList = widget.wordobj['shortdef'];
    widget.wordobj['def'][0]['sseq'][0][0][1]['dt'][1][1].forEach((obj) {
      sentences.add(widget.model.parseSentence(obj['t']));
    });

    setTransList();
  }

  void setTransList() {
    if (definitionsList.isNotEmpty) {
      widget.model.translateIBM(definitionsList).then((transList) {
        var tempList = [];
        transList.forEach((element) {
          tempList.add(element['translation']);
        });
        defTransList = tempList;
      });
    }
    if (sentences.isNotEmpty) {
      widget.model.translateIBM(sentences).then((transList) {
        var tempList = [];
        transList.forEach((element) {
          tempList.add(element['translation']);
        });
        sentenceTransList = tempList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: viewportHeight * 0.03,
            ),
            navbarButton(),
            WordHead(
                viewportHeight, viewportWidth, widget.wordobj['meta']['id']),
            Container(),
            showDefinitions ? _definitions('Definitions') : Container(),
            SizedBox(height: 15),
            showAllDefinitions
                ? Container()
                : showDefinitions
                    ? _definitionButton('More Definitions')
                    : _definitionButton('See Definitions'),
            SizedBox(height: 15),
            showDefinitions
                ? _definitionButton('Close Definitions')
                : Container(),
            _button('Sentences'),
            _definitions('Sentences'),
          ],
        ),
      ),
    );
  }

  Widget _definitionButton(String title) {
    return Container(
      width: viewportWidth * 0.4,
      height: viewportHeight * 0.045,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white24,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(23),
        ),
      ),
      child: OutlineButton(
        padding: EdgeInsets.all(0),
        splashColor: Colors.white,
        onPressed: () {
          setState(() {
            if (title == 'See Definitions') {
              showDefinitions = true;
            } else if (title == 'Close Definitions') {
              showDefinitions = false;
              showAllDefinitions = false;
            } else {
              showAllDefinitions = true;
            }
          });
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.white),
        child: Text(
          title,
          style: TextStyle(
            fontSize: viewportHeight * 0.02,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _button(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: viewportWidth * 0.6,
        child: RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: viewportHeight * 0.03,
                    fontFamily: 'Krungthep'),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
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

  Widget _definitions(String title) {
    var definitions;
    var transList;
    if (title == 'Sentences') {
      definitions = sentences;
      transList = sentenceTransList;
    } else {
      definitions = definitionsList;
      transList = defTransList;
    }
    return Container(
      width: viewportWidth * 0.8,
      height: title == 'Sentences'
          ? viewportHeight * 0.6
          : (showAllDefinitions ? viewportHeight * 0.6 : viewportHeight * 0.25),
      child: ListView.builder(
        itemCount: title != 'Sentences'
            ? (showAllDefinitions ? definitions.length : 1)
            : definitions.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                // leading: Text((index + 1).toString()),
                leading: Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                      ),
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(23),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                title: Text(
                  definitions[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: viewportHeight * 0.02,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: title == 'Sentences'
                                  ? ((currSenTransIndex == index)
                                      ? Colors.blue
                                      : Colors.white)
                                  : ((currDefTransIndex == index
                                      ? Colors.blue
                                      : Colors.white)),
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(13),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (title == 'Sentences') {
                                  if (currSenTransIndex != index) {
                                    currSenTransIndex = index;
                                  } else {
                                    currSenTransIndex = -1;
                                  }
                                  showSenTrans = !showSenTrans;
                                } else {
                                  if (currDefTransIndex != index) {
                                    currDefTransIndex = index;
                                  } else {
                                    currDefTransIndex = -1;
                                  }
                                  showDefTrans = !showDefTrans;
                                }
                              });
                            },
                            child: Icon(
                              Icons.translate,
                              size: viewportHeight * 0.03,
                              color: title == 'Sentences'
                                  ? ((currSenTransIndex == index)
                                      ? Colors.white
                                      : Theme.of(context).primaryColor)
                                  : ((currDefTransIndex == index
                                      ? Colors.white
                                      : Theme.of(context).primaryColor)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(13),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: GestureDetector(
                            onTap: () {
                              widget.model.initializeTts();
                              widget.model.ttsspeak(definitions[index]);
                            },
                            child: Icon(
                              MyFlutterApp.volume,
                              size: viewportHeight * 0.03,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              title == 'Sentences'
                  ? (currSenTransIndex == index
                      ? ListTile(
                          leading: Icon(Icons.translate),
                          title: Text(
                            transList[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: viewportHeight * 0.02,
                            ),
                          ),
                        )
                      : Container())
                  : (currDefTransIndex == index
                      ? ListTile(
                          leading: Icon(Icons.translate),
                          title: Text(
                            transList[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: viewportHeight * 0.02,
                            ),
                          ),
                        )
                      : Container()),
            ],
          );
        },
      ),
    );
  }
}
