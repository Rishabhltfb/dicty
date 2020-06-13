import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import './connected_scoped_model.dart';

class DictService extends ConnectedModel {
  Future<List> searchWordDict(String word) async {
    String key = dictKey;
    try {
      final http.Response response = await http.get(
          'https://www.dictionaryapi.com/api/v3/references/learners/json/${word}?key=${key}',
          headers: <String, String>{'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        print('Dict search success.');
        final res = json.decode(response.body);
        res.forEach((obj) {
          if (obj is String) {
            print(obj);
          } else {
            print(obj['meta']['id']);
          }
        });
        return res;
      } else {
        print('!!!1111111!');
        return null;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }
}
