import 'package:firebase_auth/firebase_auth.dart';

import '../api/keys.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedModel extends Model {
  final ibmTransKey = ApiKeys.ibmtranskey;

  FirebaseUser authenticatedUser = null;
  bool isLoading = false;
  bool isUserAuthenticated = false;
  String nativeLang = '';
  String nativeLangCode = '';
  List<String> myWords = [];
  List nativeLanguagesList = [];
  Map<String, dynamic> azureLanguages;
}
