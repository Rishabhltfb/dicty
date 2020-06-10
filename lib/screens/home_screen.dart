import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/screens/word_screen.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
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
  List<String> dict_words = [
    // 'Bra',
    'Brain',
    'Brother',
    'Breed',
    'Broke',
    'Break',
    // 'Bra',
    'Brain',
    'Brother',
    'Breed',
    'Broke',
    'Break',
    // 'Bra',
  ];

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
              setState(() {
                typing = true;
                hideButtons = true;
                showResults = true;
              });
            } else {
              FocusScope.of(context).requestFocus(FocusNode());
              _formKey.currentState.reset();
              setState(() {
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

  Widget myWordsList(context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            // spreadRadius: 1,
            // blurRadius: 2,
            // offset: Offset.fromDirection(0.7),
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      // color: Theme.of(context).accentColor,
      width: viewportWidth * 0.8,
      height: viewportHeight * 0.5,
      child: ListView.separated(
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
            trailing: Container(
              width: viewportWidth * 0.15,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.translate,
                      size: viewportHeight * 0.025,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Icon(
                    MyFlutterApp.volume,
                    size: viewportHeight * 0.025,
                    color: Theme.of(context).primaryColor,
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
                  // myWordsList(context);
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
          child: SingleChildScrollView(
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
                showMyWords ? myWordsList(context) : Container(),
                hideButtons ? Container() : _button('My Words'),
                hideButtons ? Container() : _button('Practice'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchedWords() {
    var list = [];
    dict_words.forEach((word) {
      if (word.length >= searchWord.length) {
        if (word.toLowerCase().substring(0, searchWord.length) ==
            searchWord.toLowerCase()) {
          list.add(word);
        }
      }
    });
    // print(list);
    // print(list.length);
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
