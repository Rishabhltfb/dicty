import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var viewportHeight;
  var viewportWidth;
  var lang = 'Hebrew';
  var email = 'avishay89051@gmail.com';

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
            onPressed: () {}),
      ),
    );
  }

  Widget _dropdown() {
    return FlatButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      onPressed: () {},
      child: new DropdownButton<String>(
        hint: Text(
          lang,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        items: <String>[
          'Hebrew',
          'Hindi',
          'Chinese',
          'English',
        ].map((String value) {
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getViewportWidth(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                child: _dropdown(),
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
              _button('English'),
              _button('Notifications On'),
              _button('Logout'),
              Text(email),
            ],
          ),
        ),
      ),
    );
  }
}
