import 'dart:convert';
import 'dart:async';

import 'package:dictyapp/helpers/practice.dart';
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
      prefs.setString('uid', authenticatedUser.uid);
      prefs.setString('email', authenticatedUser.email);
      uid = authenticatedUser.uid;
      email = authenticatedUser.email;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> autoAuthenticate() async {
    print('Inside auto-authenticate');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('shared prefs loaded');
    String token = prefs.getString('token');

    if (token != null) {
      String tempuid = prefs.getString('uid');
      String tempemail = prefs.getString('email');
      String limit = prefs.getString('limit');
      String expiry = prefs.getString('expiryTime');
      if (limit != null) {
        youglishlimit = int.parse(limit);
      }
      final DateTime now = DateTime.now();
      if (expiry != null && youglishlimit > 19) {
        DateTime expiryTime = DateTime.parse(expiry);
        if (expiryTime.isBefore(now)) {
          youglishlimit = 0;
          prefs.setString('limit', youglishlimit.toString());
        } else {
          youglishlimit = int.parse(limit);
        }
      }
      uid = tempuid;
      email = tempemail;
      return true;
    } else {
      return false;
    }
  }

  Future<Null> signOut() async {
    googleSignIn.signOut();
    authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // await prefs.remove('token');
    // await prefs.remove('uid');
    // await prefs.remove('email');
    // await prefs.remove('native');
    // await prefs.remove('nativeCode');
    uid = null;
    myWords = [];

    authenticatedUser = null;
    email = null;
    nativeLang = '';
    nativeLangCode = '';
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

  Future<bool> addFavWord(Map wordobj) async {
    final Map<String, dynamic> addedWord = {'wordobj': wordobj};

    try {
      final http.Response response = await http.post(
          'https://dicty-app.firebaseio.com/${uid}/words.json',
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
    if (nativelang != null && nLC != null) {
      nativeLang = nativelang;
      nativeLangCode = nLC;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> fetchMyWords() async {
    isLoading = true;
    notifyListeners();
    realpraticeWords = practiceOptions;
    return await http
        .get('https://dicty-app.firebaseio.com/${uid}/words.json')
        .then<bool>((http.Response response) {
      if (response.statusCode == 200) {
        print('inside fetch success');
        final List<Map> fetchedWordList = [];
        final Map<String, dynamic> wordListData = json.decode(response.body);
        if (wordListData == null) {
          print('No list element');
          myWords = [];
          isLoading = false;
          notifyListeners();
          return true;
        }

        wordListData.forEach((String id, dynamic entryData) {
          final Map entry = entryData['wordobj'];
          fetchedWordList.add(entry);
          // print(entry);
        });
        myWords = fetchedWordList;
        List<String> temp = [];
        fetchedWordList.forEach((wordobj) {
          temp.add(wordobj['meta']['id']);
        });
        realpraticeWords = practiceOptions + temp;
      } else {
        print(
            "Fetch Words Error: ${json.decode(response.body)["error"].toString()}");
        return false;
      }
      isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      print("Fetch Word Error: ${error.toString()}");
      isLoading = false;
      notifyListeners();
      return false;
    });
  }
}
