import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './connected_scoped_model.dart';

class YoutubeService extends ConnectedModel {
  Future<List> searchYoutube(String word) async {
    String key = youtubeKey;
    try {
      final http.Response response = await http.get(
          'https://youglish.com/api/v1/videos/search?key=${key}&query=${word}&lg=english&accent=us',
          headers: <String, String>{'Content-Type': 'application/json'});
      youglishlimit++;

      if (response.statusCode == 200) {
        print('Youglish search success.');
        final res = json.decode(response.body);
        // print('Youglish list is : ${res['results']}');
        // setYouglishLimit();
        return res['results'];
      } else {
        print('Invalid status code : ${response.statusCode}');
        return null;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  void setYouglishExpiry() async {
    final DateTime now = DateTime.now();
    final DateTime expiryTime = now.add(Duration(days: 1));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('limit', youglishlimit.toString());
    prefs.setString('expiryTime', expiryTime.toIso8601String());
  }

  // void resetExpiry() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String expiryTime = prefs.getString('expiryTime');

  //   final DateTime now = DateTime.now();
  // }

  // void updateLimit() async {
  //   youglishlimit++;
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String limit = youglishlimit.toString();
  //   prefs.setString('limit', limit);
  //   final DateTime now = DateTime.now();
  //   final DateTime expiryTime = now.add(Duration(days: 1));
  // }
}
