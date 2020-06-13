import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/screens/word_screen.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

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
  List<dynamic> dict_words = [];
  @override
  void initState() {
    widget.model.fetchWords().then((_) {
      mywords = widget.model.myWords;
    });
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> mywords = [
    'Psychology',
    'Brother',
    'Winner',
    'Complex',
    'Song',
    'Practice',
  ];

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
          onChanged: (String value) {
            if (value != '') {
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
              _formKey.currentState.reset();
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
                var word = mywords[index];
                return ListTile(
                  title: Text(
                    word,
                    style: TextStyle(
                        fontFamily: 'Krungthep',
                        color: Theme.of(context).primaryColor),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WordScreen(word),
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
                            List wordList = [];
                            wordList.add(word);
                            model.translateIBM(wordList);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            MyFlutterApp.volume,
                            size: viewportHeight * 0.02,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            model.tTSIBM(word);
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
                    fontSize: title != 'Speak Instead'
                        ? viewportHeight * 0.03
                        : viewportHeight * 0.015,
                    fontFamily: 'Krungthep'),
              ),
            ),
            onPressed: () {
              if (title == 'My Words') {
                setState(() {
                  hideButtons = true;
                  showMyWords = true;
                });
              } else if (title == 'Practice') {
                Navigator.of(context).pushNamed('/practice');
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
        body: GestureDetector(
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
                    showMyWords ? myWordsList(context, model) : Container(),
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WordScreen(list[index]),
                ),
              );
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
