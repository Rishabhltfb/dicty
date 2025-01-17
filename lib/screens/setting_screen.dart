import 'dart:async';

import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/helpers/flags.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var viewportHeight;
  var viewportWidth;
  var lang = '';
  var email = 'avishay89051@gmail.com';
  String flag = '🇮🇳';
  List<String> languages = [];

  String findFlag(String langName) {
    return flags[langName] != null ? flags[langName] : '🇮🇳';
  }

  Widget _button(String title, MainModel model) {
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
                    fontSize: viewportHeight * 0.028,
                    fontFamily: 'Krungthep'),
              ),
            ),
            onPressed: () {
              if (title == 'Logout') {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
                Timer(Duration(microseconds: 500), () {
                  model.signOut();
                });
              }
            }),
      ),
    );
  }

  Widget _dropdown(MainModel model) {
    return FlatButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            flag,
            textScaleFactor: 1.5,
          ),
          Container(
            width: viewportWidth * 0.3,
            height: viewportHeight * 0.06,
            child: new DropdownButton<String>(
              iconEnabledColor: Theme.of(context).primaryColor,
              hint: Text(
                lang,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              isExpanded: true,
              items: languages.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(findFlag(value) + '  ' + value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  flag = findFlag(value);
                  var elem = model.nativeLanguagesList.firstWhere((obj) {
                    return obj['name'] == value;
                  });
                  String langCode = elem['language'];
                  lang = value;
                  model.addNativeLang(lang, langCode);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        body: ScopedModelDescendant<MainModel>(
          builder: (context, child, model) {
            lang = model.nativeLang;
            model.nativeLanguagesList.forEach((obj) {
              languages.add(obj['name']);
            });
            email = model.authenticatedUser.email;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
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
                  ),
                  DictyLabel(viewportHeight, viewportWidth, ''),
                  SizedBox(
                    height: viewportHeight * 0.13,
                  ),
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
                    width: viewportWidth * 0.6,
                    child: _dropdown(model),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Center(
                      child: Text(
                        'You\'re Learning',
                        style: TextStyle(
                            fontSize: viewportHeight * 0.028,
                            fontFamily: 'Krungthep'),
                      ),
                    ),
                  ),
                  _button('English', model),
                  _button('Notifications On', model),
                  _button('Logout', model),
                  Text(email),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
