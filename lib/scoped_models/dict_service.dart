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
        // res.forEach((obj) {
        //   if (obj is String) {
        //     print(obj);
        //   } else {
        //     print(obj['meta']['id']);
        //   }
        // });
        return res;
      } else {
        print('Invalid status code : ${response.statusCode}');
        return null;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  String parseSentence(String sentence) {
    String _newString = '';
    bool flag = false;
    for (int i = 0; i < sentence.length; i++) {
      if (sentence[i] == '{') {
        flag = true;
      } else if (sentence[i] == '}') {
        flag = false;
        i++;
      }
      if (flag) {
        // print(sentence[i]);
      } else {
        _newString = _newString + sentence[i];
      }
    }
    return _newString;
  }
}
