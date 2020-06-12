import 'package:dictyapp/helpers/dimensions.dart';
import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/widgets/dictyHead.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthScreen extends StatefulWidget {
  final MainModel model;
  AuthScreen(this.model);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var viewportHeight;
  var viewportWidth;
  bool haveNative = false;
  @override
  void initState() {
    widget.model.haveNative().then((value) {
      haveNative = value;
    });
    super.initState();
  }

  Widget _signInButtonF(String title, String img, String method) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: OutlineButton(
        splashColor: Colors.white,
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage(img), height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: viewportHeight * 0.025,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton(MainModel model, BuildContext context) {
    return RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image(image: AssetImage('assets/images/google.jpeg'), height: 20.0),
            Text(
              'Sign In with Google',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.55),
                  fontSize: viewportHeight * 0.025),
            ),
          ],
        ),
        onPressed: () {
          model.signIn().then((bool value) {
            if (value) {
              haveNative
                  ? Navigator.of(context).pushReplacementNamed('/home')
                  : Navigator.of(context).pushReplacementNamed('/langSelect');
            } else {
              print('Failed');
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text('SignIn Failed')],
                  ),
                ),
              );
            }
          }).catchError((err) {
            print(err);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    viewportHeight = getViewportHeight(context);
    viewportWidth = getDeviceWidth(context);
    return SafeArea(
      child: Scaffold(body: SingleChildScrollView(
        child: ScopedModelDescendant<MainModel>(
          builder: (context, child, model) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    width: viewportWidth,
                    child: DictyLabel(
                        viewportHeight, viewportWidth, 'Read, Learn, Repeat.'),
                  ),
                ),
                SizedBox(height: viewportHeight * 0.3),
                Container(
                  width: viewportWidth * 0.6,
                  child: _signInButton(model, context),
                ),
                _signInButtonF('Sign Up with Google',
                    'assets/images/google.jpeg', 'signup'),
              ],
            );
          },
        ),
      )),
    );
  }
}
