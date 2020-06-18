import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import './connected_scoped_model.dart';

class GiphyService extends ConnectedModel {
  Future<List> searchGiphy(String word) async {
    String key = giphyKey;
    try {
      final http.Response response = await http.get(
          'https://api.giphy.com/v1/gifs/search?api_key=${key}&q=${word}&limit=10&offset=0&rating=G&lang=en',
          headers: <String, String>{'Content-Type': 'application/json'});
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Giphy search success.');
        final res = json.decode(response.body);
        List list = [];
        res['data'].forEach((obj) {
          list.add(obj['images']['downsized_large']);
        });
        return list;
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
