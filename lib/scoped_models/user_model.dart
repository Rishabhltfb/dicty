import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './connected_scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserModel extends ConnectedModel {
  FirebaseUser get getAuthenticatedUser {
    print('Inside get authenticated User');
    return authenticatedUser;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<bool> signIn() async {
    print('Inside google SignIn');
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: gSA.accessToken,
      idToken: gSA.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;
    if (user != null) {
      authenticatedUser = user;
      var token;
      await user.getIdToken().then((value) {
        token = value.token;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('token', token);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<Null> signOut() async {
    googleSignIn.signOut();
    authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('native');
    await prefs.remove('nativeCode');
    print('user sign out');
  }

  Future<bool> addNativeLang(String lang, String langCode) async {
    nativeLang = lang;
    nativeLangCode = langCode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool res = false;
    bool res1 = false;
    bool res2 = false;

    await prefs.setString('native', lang).then((value) {
      res1 = value;
    });
    await prefs.setString('nativeCode', langCode).then((value) {
      res2 = value;
    });
    if (res1 && res2) {
      res = true;
    }

    return res;
  }

  Future<bool> addFavWord(String word) async {
    final Map<String, dynamic> addedWord = {'word': word};

    try {
      final http.Response response = await http.post(
          'https://dicty-app.firebaseio.com/${authenticatedUser.uid}/words.json',
          body: json.encode(addedWord));

      if (response.statusCode != 200 || response.statusCode != 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> haveNative() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String nativelang = prefs.getString('native');
    String nLC = prefs.getString('nativeCode');
    nativeLang = nativelang;
    nativeLangCode = nLC;
    if (nativelang != null && nativeLangCode != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<Null> fetchWords() async {
    isLoading = true;
    notifyListeners();
    return await http
        .get(
            'https://dicty-app.firebaseio.com/${authenticatedUser.uid}/words.json')
        .then<Null>((http.Response response) {
      if (response.statusCode == 200) {
        final List<String> fetchedWordList = [];
        final Map<String, dynamic> wordListData = json.decode(response.body);
        if (wordListData == null) {
          isLoading = false;
          notifyListeners();
          return;
        }

        wordListData.forEach((String id, dynamic entryData) {
          final String entry = entryData['word'];
          fetchedWordList.add(entry);
          // print(entry);
        });
        myWords = fetchedWordList;
      } else {
        print(
            "Fetch Words Error: ${json.decode(response.body)["error"].toString()}");
      }
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      print("Fetch Word Error: ${error.toString()}");
      isLoading = false;
      notifyListeners();
      return;
    });
  }
}
