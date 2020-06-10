import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/my_flutter_app_icons.dart';
import 'package:dictyapp/widgets/wordHead.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  final word;
  VideoScreen(this.word);
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  var viewportHeight;
  var viewportWidth;
  bool showDefinitions = false;
  bool showAllDefinitions = false;
  List<String> definitions = [
    'a male who has the same parents as another or one parent in common with another. (noun)'
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
            showDefinitions ? _definitions() : Container(),
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
            _button('In Videos'),
            SizedBox(height: viewportHeight * 0.05),
            Container(
              height: viewportHeight * 0.3,
              width: viewportWidth,
              child: Image.asset(
                'assets/images/youtube.png',
                fit: BoxFit.cover,
              ),
            ),
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
              var firstDefinition = definitions[0];
              List<String> list = [];
              list.add(firstDefinition);
              definitions = list;
            } else {
              showAllDefinitions = true;

              definitions.add(
                  'a male who has the same parents as another or one parent in common with another. (noun)');
              definitions.add(
                  'a male who has the same parents as another or one parent in common with another. (noun)');
              definitions.add(
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

  Widget _definitions() {
    return Container(
      width: viewportWidth * 0.8,
      height: showAllDefinitions ? viewportHeight * 0.6 : viewportHeight * 0.25,
      child: ListView.builder(
        itemCount: definitions.length,
        itemBuilder: (context, index) {
          return ListTile(
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
