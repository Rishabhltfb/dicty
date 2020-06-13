import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/screens/sentences_screen.dart';
import 'package:dictyapp/screens/video_screen.dart';
import 'package:dictyapp/widgets/wordHead.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class WordScreen extends StatefulWidget {
  final word;
  WordScreen(this.word);
  @override
  _WordScreenState createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  var viewportHeight;
  var viewportWidth;
  bool showalldefinitions = false;
  bool fav = false;
  List youtubeList = [];
  List<String> definitions = [
    'a male who has the same parents as another or one parent in common with another. (noun)'
  ];

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: ScopedModelDescendant<MainModel>(
          builder: (context, child, model) {
            fav = model.myWords.contains(widget.word);
            if (youtubeList.length == 0) {
              model.searchYoutube(widget.word).then((value) {
                youtubeList = value;
              });
            }
            return Column(
              children: <Widget>[
                SizedBox(
                  height: viewportHeight * 0.03,
                ),
                navbarButton(),
                WordHead(viewportHeight, viewportWidth, widget.word),
                Container(),
                _definitions(),
                SizedBox(height: 15),
                showalldefinitions
                    ? _moreButton('Less Difinitions')
                    : _moreButton('More Difinitions'),
                _button(title: 'Sentences'),
                _button(title: 'Movie Texts'),
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
              definitions.add(
                  'a male who has the same parents as another or one parent in common with another. (noun)');
              definitions.add(
                  'a male who has the same parents as another or one parent in common with another. (noun)');
              definitions.add(
                  'a male who has the same parents as another or one parent in common with another. (noun)');
            });
          } else {
            setState(() {
              showalldefinitions = false;
              var definition1 = definitions[1];
              definitions = [];
              definitions.add(definition1);
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SentencesScreen(widget.word),
                  ),
                );
              } else if (title == 'In Videos') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoScreen(widget.word, youtubeList),
                  ),
                );
              } else if (title == '+ Add to List') {
                if (!fav) {
                  print('Added');
                  setState(() {
                    fav = true;
                    model.myWords.add(widget.word);
                  });
                  model.addFavWord(widget.word);
                }
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

  Widget _definitions() {
    return Container(
      width: viewportWidth * 0.8,
      height: showalldefinitions ? viewportHeight * 0.6 : viewportHeight * 0.25,
      child: ListView.builder(
        itemCount: definitions.length,
        itemBuilder: (context, index) {
          return ListTile(
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
                      child: Icon(
                        Icons.translate,
                        size: viewportHeight * 0.03,
                        color: Theme.of(context).primaryColor,
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
                      child: Icon(
                        MyFlutterApp.volume,
                        size: viewportHeight * 0.03,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
