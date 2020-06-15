import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

import './connected_scoped_model.dart';

class LangService extends ConnectedModel {
  Future<Null> fetchLangs() async {
    String username = 'apikey';
    String password = ibmTransKey;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    try {
      final http.Response response = await http.get(
          'https://api.eu-gb.language-translator.watson.cloud.ibm.com/instances/ab06a5e8-c569-404c-96ad-9f159dbbca86/v3/identifiable_languages?version=2018-05-01',
          headers: <String, String>{
            'authorization': basicAuth,
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        print('fetch success in lang');
        final Map<String, dynamic> res = json.decode(response.body);
        nativeLanguagesList = res['languages'];

        // nativeLanguageList = list;
      } else {
        print('Invalid status code : ${response.statusCode}');
      }
    } catch (err) {
      print(err);
    }
  }

  Future<List> translateIBM(List wordList) async {
    String username = 'apikey';
    String password = ibmTransKey;
    String nativelangcode = nativeLangCode;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    List<String> words = [];
    wordList.forEach((word) {
      words.add(word);
    });
    final Map<String, dynamic> body = {
      'text': words,
      'model_id': "en-${nativelangcode}",
    };

    try {
      final http.Response response = await http.post(
          'https://api.eu-gb.language-translator.watson.cloud.ibm.com/instances/ab06a5e8-c569-404c-96ad-9f159dbbca86/v3/translate?version=2018-05-01',
          body: json.encode(body),
          headers: <String, String>{
            'authorization': basicAuth,
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        print('translation success in lang');
        final Map<String, dynamic> res = json.decode(response.body);

        // print(res);
        List translations = res['translations'];
        // translations.forEach((obj) {
        //   print(obj['translation']);
        // });
        return translations;
      } else {
        print('Invalid status code : ${response.statusCode}');
        return [];
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<Null> tTSIBM(String text) async {
    String username = 'apikey';
    String password = ibmTTSKey;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final Map<String, dynamic> body = {'text': text};

    try {
      final http.Response response = await http.post(
          'https://api.eu-gb.text-to-speech.watson.cloud.ibm.com/instances/6cf5f697-4a9f-4f4c-be05-235f6f08c685/v1/synthesize',
          body: json.encode(body),
          headers: <String, String>{
            'authorization': basicAuth,
            'Content-Type': 'application/json',
            'Accept': 'audio/wav'
          });

      if (response.statusCode == 200) {
        print('translation success in lang');
        final File res = json.decode(response.body);

        print(res);
      } else {
        print('Invalid status code : ${response.statusCode}');
      }
    } catch (err) {
      print(err);
    }
  }

  FlutterTts flutterTts;

  initializeTts() {
    flutterTts = FlutterTts();
  }

  Future ttsspeak(String text) async {
    if (text != null && text.isNotEmpty) {
      var result = await flutterTts.speak(text);
      if (result == 1) {
        print('Playing audio');
      }
    }
  }

  Future ttsstop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      print('Stop playing');
    }
  }
}
