import 'package:dictyapp/models/user.dart';

import '../api/keys.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedModel extends Model {
  final uri = ApiKeys.uri;

  User authenticatedUser = null;
  bool isLoading = false;
  bool isUserAuthenticated = false;
}
