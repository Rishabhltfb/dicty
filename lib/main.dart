import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/screens/auth_screen.dart';
import 'package:dictyapp/screens/home_screen.dart';
import 'package:dictyapp/screens/langSelect_screen.dart';
import 'package:dictyapp/screens/learnLang_screen.dart';
import 'package:dictyapp/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffF29C5D),
      statusBarIconBrightness: Brightness.dark,
    ));
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: Color(0xffF29C5D),
            primaryColor: Color(0xffF29C5D),
            accentColor: Colors.white,
            textTheme: TextTheme(
              bodyText2: TextStyle(
                color: Colors.white,
              ),
              button: TextStyle(
                color: Color(0xffF29C5D),
              ),
            ),
            iconTheme: IconThemeData(color: Colors.white)),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (BuildContext context) => AuthScreen(),
          '/langSelect': (BuildContext context) => LangSelectScreen(),
          '/learnLang': (BuildContext context) => LearnLangScreen(),
          '/home': (BuildContext context) => HomeScreen(),
          '/settings': (BuildContext context) => SettingScreen(),
        },
      ),
    );
  }
}
