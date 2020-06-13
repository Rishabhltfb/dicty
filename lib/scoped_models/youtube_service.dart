import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import './connected_scoped_model.dart';

class YoutubeService extends ConnectedModel {
  Future<List> searchYoutube(String word) async {
    String key = youtubeKey;
    try {
      final http.Response response = await http.get(
          'https://youglish.com/api/v1/videos/search?key=${key}&query=${word}&lg=english&accent=us',
          headers: <String, String>{'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        print('Youglish search success.');
        final res = json.decode(response.body);

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
}
