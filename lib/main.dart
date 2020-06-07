import 'package:dictyapp/scoped_models/main_scoped_model.dart';
import 'package:dictyapp/screens/auth_screen.dart';
import 'package:flutter/material.dart';
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
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffF29C5D),
          primaryColor: Color(0xffF29C5D),
          accentColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (BuildContext context) => AuthScreen(),
        },
      ),
    );
  }
}
