import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/widgets/wordHead.dart';
import 'package:flutter/material.dart';

class SentencesScreen extends StatefulWidget {
  final word;
  SentencesScreen(this.word);
  @override
  _SentencesScreenState createState() => _SentencesScreenState();
}

class _SentencesScreenState extends State<SentencesScreen> {
  var viewportHeight;
  var viewportWidth;
  bool showDefinitions = false;
  bool showAllDefinitions = false;
  List<String> definitionsList = [
    'a male who has the same parents as another or one parent in common with another. (noun)'
  ];
  List<String> sentences = [
    'a male who has the same parents as another or one parent in common with another. (noun)',
    'a male who has the same parents as another or one parent in common with another. (noun)',
    'a male who has the same parents as another or one parent in common with another. (noun)',
    'a male who has the same parents as another or one parent in common with another. (noun)',
    'a male who has the same parents as another or one parent in common with another. (noun)',
  ];
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
            WordHead(viewportHeight, viewportWidth, widget.word),
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
              var firstDefinition = definitionsList[0];
              List<String> list = [];
              list.add(firstDefinition);
              definitionsList = list;
            } else {
              showAllDefinitions = true;

              definitionsList.add(
                  'a male who has the same parents as another or one parent in common with another. (noun)');
              definitionsList.add(
                  'a male who has the same parents as another or one parent in common with another. (noun)');
              definitionsList.add(
                  'a male who has the same parents as another or one parent in common with another. (noun)');
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
    if (title == 'Sentences') {
      definitions = sentences;
    } else {
      definitions = definitionsList;
    }
    return Container(
      width: viewportWidth * 0.8,
      height: title == 'Sentences'
          ? viewportHeight * 0.6
          : (showAllDefinitions ? viewportHeight * 0.6 : viewportHeight * 0.25),
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
