import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LangSelectScreen extends StatefulWidget {
  @override
  _LangSelectScreenState createState() => _LangSelectScreenState();
}

class _LangSelectScreenState extends State<LangSelectScreen> {
  var viewportHeight;
  var viewportWidth;
  var lang = 'Afrikaans';
  List<String> nativeLanguages = [];

  Widget _dropdown() {
    return FlatButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      onPressed: () {},
      child: Container(
        width: viewportWidth * 0.3,
        height: viewportHeight * 0.08,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            new DropdownButton<String>(
              hint: Text(
                lang,
                overflow: TextOverflow.clip,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              items: nativeLanguages.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  lang = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _continueButton(MainModel model) {
    return RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          'Continue',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: viewportHeight * 0.025,
              fontFamily: 'Krungthep'),
        ),
        onPressed: () {
          var elem = model.nativeLanguagesList.firstWhere((obj) {
            return obj['name'] == lang;
          });
          String langCode = elem['language'];
          model.addNativeLang(lang, langCode).then((value) {
            if (value) {
              Navigator.of(context).pushReplacementNamed('/learnLang');
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getDeviceWidth(context);
    return SafeArea(
      child: Scaffold(
        body: ScopedModelDescendant<MainModel>(
          builder: (context, child, model) {
            List<String> tempList = [];
            model.nativeLanguagesList.forEach((obj) {
              tempList.add(obj['name']);
            });
            nativeLanguages = tempList;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Container(
                      width: viewportWidth,
                      child: DictyLabel(viewportHeight, viewportWidth,
                          'Read, Learn, Repeat.'),
                    ),
                  ),
                  SizedBox(height: viewportHeight * 0.2),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'You\'re Native at',
                        style: TextStyle(
                            fontSize: viewportHeight * 0.028,
                            fontFamily: 'Krungthep'),
                      ),
                    ),
                  ),
                  Container(
                    width: viewportWidth * 0.5,
                    child: _dropdown(),
                  ),
                  SizedBox(height: viewportHeight * 0.35),
                  Container(
                    width: viewportWidth * 0.5,
                    child: _continueButton(model),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
