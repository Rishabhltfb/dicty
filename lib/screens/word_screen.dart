import 'dart:async';

import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/screens/giphy_screen.dart';
import 'package:dictyapp/screens/sentences_screen.dart';
import 'package:dictyapp/screens/video_screen.dart';
import 'package:dictyapp/widgets/wordHead.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class WordScreen extends StatefulWidget {
  final wordobj;
  final MainModel model;
  WordScreen(this.wordobj, this.model);
  @override
  _WordScreenState createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  var viewportHeight;
  var viewportWidth;
  bool showalldefinitions = false;
  bool fav = false;
  bool _isLoading = false;
  List youtubeList = [];
  int currDefTransindex;
  List definitions = [];
  List defTransList = [];
  @override
  void initState() {
    currDefTransindex = -1;
    _isLoading = true;
    super.initState();

    if (widget.wordobj is String) {
      print('wordobj is String');
    } else {
      List tempList = [];
      widget.model.myWords.forEach((wordobj) {
        tempList.add(wordobj['meta']['id']);
      });
      fav = tempList.contains(widget.wordobj['meta']['id']);
    }
    // if (youtubeList.length == 0 && widget.model.youglishlimit < 29) {
    //   widget.model.searchYoutube(widget.wordobj['meta']['id']).then((value) {
    //     youtubeList = value;
    //   });
    // }
    if (definitions.length == 0) {
      definitions = widget.wordobj['shortdef'];
    }
    if (defTransList.length == 0) {
      widget.model.translateIBM(definitions).then((transList) {
        var tempList = [];
        transList.forEach((element) {
          tempList.add(element['translation']);
        });
        defTransList = tempList;
        Timer(Duration(milliseconds: 500), () {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: ScopedModelDescendant<MainModel>(
          builder: (context, child, model) {
            return _isLoading
                ? Container(
                    height: viewportHeight,
                    width: viewportWidth,
                    child: Center(child: CircularProgressIndicator()))
                : Column(
                    children: <Widget>[
                      SizedBox(
                        height: viewportHeight * 0.03,
                      ),
                      navbarButton(),
                      WordHead(viewportHeight, viewportWidth,
                          widget.wordobj['meta']['id'], model),
                      _definitions(model),
                      SizedBox(height: 15),
                      showalldefinitions
                          ? _moreButton('Less Difinitions')
                          : _moreButton('More Difinitions'),
                      SizedBox(
                        height: viewportHeight * 0.04,
                      ),
                      _button(title: 'Sentences', model: model),
                      _button(title: 'Giphy', model: model),
                      _button(title: 'In Videos'),
                      _button(title: '+ Add to List', model: model),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _moreButton(String title) {
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
          if (title == 'More Difinitions') {
            setState(() {
              showalldefinitions = true;
            });
          } else {
            setState(() {
              showalldefinitions = false;
            });
          }
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

  Widget _button({String title, MainModel model}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: viewportWidth * 0.6,
        child: RaisedButton(
            color: title == '+ Add to List'
                ? fav ? Color(0xfff7c49e) : Colors.white
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                    color: title == '+ Add to List'
                        ? fav ? Colors.white : Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor,
                    fontSize: viewportHeight * 0.03,
                    fontFamily: 'Krungthep'),
              ),
            ),
            onPressed: () {
              if (title == 'Sentences') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        SentencesScreen(widget.wordobj, model),
                  ),
                );
              } else if (title == 'In Videos') {
                if (widget.model.youglishlimit < 29) {
                  Navigator.of(context).push(
                    // MaterialPageRoute(
                    //   builder: (context) => VideoScreen(
                    //     widget.wordobj['meta']['id'],
                    //     youtubeList,
                    //   ),
                    // ),  actual navigator
                    MaterialPageRoute(
                      builder: (context) => VideoScreen(
                          widget.wordobj['meta']['id'], youtubeList, model),
                    ),
                  );
                }
              } else if (title == '+ Add to List') {
                if (!fav) {
                  print('Added');
                  setState(() {
                    fav = true;
                    model.myWords.add(widget.wordobj);
                    widget.model.fetchMyWords();
                  });
                  model.addFavWord(widget.wordobj);
                }
              } else if (title == 'Giphy') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        GiphyScreen(widget.wordobj['meta']['id'], model),
                  ),
                );
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

  Widget _definitions(MainModel model) {
    return Container(
      width: viewportWidth * 0.8,
      // height: showalldefinitions ? viewportHeight * 0.6 : viewportHeight * 0.25,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: showalldefinitions ? definitions.length : 1,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
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
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: viewportHeight * 0.02,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: definitions[index]),
                      TextSpan(
                        text: '. (Noun)',
                        style: TextStyle(
                            fontSize: viewportHeight * 0.018,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
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
                              color: currDefTransindex == index
                                  ? Colors.blue
                                  : Colors.white,
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
                                if (currDefTransindex == index) {
                                  currDefTransindex = -1;
                                } else {
                                  currDefTransindex = index;
                                }
                              });
                            },
                            child: Icon(
                              Icons.translate,
                              size: viewportHeight * 0.03,
                              color: currDefTransindex == index
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
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
                              model.initializeTts();
                              model.ttsspeak(definitions[index]);
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
              currDefTransindex == index
                  ? ListTile(
                      leading: Icon(Icons.translate),
                      title: Text(
                        defTransList[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: viewportHeight * 0.02,
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
